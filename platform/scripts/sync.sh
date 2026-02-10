#!/usr/bin/env bash
set -euo pipefail

TARGETS_FILE="${1:-sync/targets.example.yaml}"
TEMPLATES_FILE="${2:-platform/repo-templates/templates.yaml}"
TEMPLATES_ROOT="${3:-platform/repo-templates}"
DRY_RUN="${DRY_RUN:-false}"
DATE_TAG="$(date +%Y%m%d)"
FORCE_OVERWRITE_DOCS="${FORCE_OVERWRITE_DOCS:-false}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

resolve_path() {
  local path_value="$1"
  if [[ "$path_value" = /* ]]; then
    printf "%s\n" "$path_value"
  else
    printf "%s/%s\n" "$(pwd)" "$path_value"
  fi
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require_cmd git
GH_BIN="${GH_BIN:-gh}"
require_cmd "$GH_BIN"
require_cmd timeout
YQ_BIN="$("${ROOT_DIR}/scripts/ensure-yq.sh")"
PATH="$(dirname "$YQ_BIN"):$PATH"
require_cmd yq

RETRY_ATTEMPTS="${RETRY_ATTEMPTS:-3}"
RETRY_BASE_DELAY="${RETRY_BASE_DELAY:-2}"
ASDEV_CLONE_PARALLELISM="${ASDEV_CLONE_PARALLELISM:-3}"
ASDEV_HEAVY_JOB_PARALLELISM="${ASDEV_HEAVY_JOB_PARALLELISM:-2}"
ASDEV_WORKER_CAP="${ASDEV_WORKER_CAP:-6}"
ASDEV_E2E_WORKERS="${ASDEV_E2E_WORKERS:-1}"
CLONE_TIMEOUT_SECONDS="${CLONE_TIMEOUT_SECONDS:-90}"

echo "Resource policy (sync): clone_parallelism=${ASDEV_CLONE_PARALLELISM} heavy_job_parallelism=${ASDEV_HEAVY_JOB_PARALLELISM} worker_cap=${ASDEV_WORKER_CAP} e2e_workers=${ASDEV_E2E_WORKERS} clone_timeout_seconds=${CLONE_TIMEOUT_SECONDS}"

retry_cmd() {
  local attempts="$1"
  shift
  local delay="$RETRY_BASE_DELAY"
  local attempt=1

  while true; do
    if "$@"; then
      return 0
    fi

    if [[ "$attempt" -ge "$attempts" ]]; then
      echo "Command failed after ${attempts} attempts: $*" >&2
      return 1
    fi

    echo "Transient failure (attempt ${attempt}/${attempts}). Retrying in ${delay}s..." >&2
    sleep "$delay"
    delay=$((delay * 2))
    attempt=$((attempt + 1))
  done
}

TARGETS_FILE="$(resolve_path "$TARGETS_FILE")"
TEMPLATES_FILE="$(resolve_path "$TEMPLATES_FILE")"
TEMPLATES_ROOT="$(resolve_path "$TEMPLATES_ROOT")"

if [[ ! -f "$TARGETS_FILE" ]]; then
  echo "Targets file not found: $TARGETS_FILE" >&2
  exit 1
fi

if [[ ! -f "$TEMPLATES_FILE" ]]; then
  echo "Templates manifest not found: $TEMPLATES_FILE" >&2
  exit 1
fi

lookup_template_path() {
  local template_id="$1"
  yq -r ".templates[] | select(.id == \"${template_id}\") | .path" "$TEMPLATES_FILE"
}

lookup_template_ref() {
  local template_id="$1"
  yq -r ".templates[] | select(.id == \"${template_id}\") | .source_ref" "$TEMPLATES_FILE"
}

copy_template() {
  local repo_dir="$1"
  local template_id="$2"

  local relative_path
  relative_path="$(lookup_template_path "$template_id")"
  if [[ -z "$relative_path" || "$relative_path" == "null" ]]; then
    echo "Unknown template id: $template_id" >&2
    return 1
  fi

  local src_path="$TEMPLATES_ROOT/$relative_path"
  local dest_path="$repo_dir/$relative_path"

  if [[ "$FORCE_OVERWRITE_DOCS" != "true" ]] && [[ -f "$dest_path" ]]; then
    if [[ "$relative_path" == "README.md" || "$relative_path" == "CONTRIBUTING.md" ]]; then
      echo "Preserving existing documentation file: $relative_path"
      return 0
    fi
  fi

  if [[ ! -f "$src_path" ]]; then
    echo "Template file missing: $src_path" >&2
    return 1
  fi

  mkdir -p "$(dirname "$dest_path")"
  cp "$src_path" "$dest_path"
}

create_pr_body() {
  local repo_name="$1"
  local refs_csv="$2"

  cat <<BODY
## Summary

Sync ASDEV Level 0 templates to target repository:
- ${repo_name}

## Standards Trace

${refs_csv}

## Notes

- Distribution model: PR-only
- Merge is optional for consumer repo owners
- Non-adoption is captured by divergence reporting
BODY
}

work_root="$(mktemp -d)"
trap 'rm -rf "$work_root"' EXIT

count_targets="$(yq -r '.targets | length' "$TARGETS_FILE")"
if [[ "$count_targets" == "0" ]]; then
  echo "No targets found in $TARGETS_FILE"
  exit 0
fi

success=0
failed=0
skipped=0

for ((i=0; i<count_targets; i++)); do
  repo="$(yq -r ".targets[$i].repo" "$TARGETS_FILE")"
  default_branch="$(yq -r ".targets[$i].default_branch // \"main\"" "$TARGETS_FILE")"

  if [[ -z "$repo" || "$repo" == "null" ]]; then
    echo "Skipping target index $i due to missing repo"
    ((skipped+=1))
    continue
  fi

  repo_dir="$work_root/${repo##*/}"
  branch_name="chore/asdev-sync-${DATE_TAG}"

  echo "Processing: $repo"

  if ! retry_cmd "$RETRY_ATTEMPTS" timeout "$CLONE_TIMEOUT_SECONDS" "$GH_BIN" repo clone "$repo" "$repo_dir" -- -q; then
    echo "Failed to clone $repo"
    ((failed+=1))
    continue
  fi

  pushd "$repo_dir" >/dev/null

  git checkout -b "$branch_name" >/dev/null 2>&1 || git checkout "$branch_name" >/dev/null 2>&1

  refs=""
  mapfile -t templates < <(yq -r ".targets[$i].templates[]?" "$TARGETS_FILE")
  mapfile -t optional_features < <(yq -r ".targets[$i].optional_features[]?" "$TARGETS_FILE")
  mapfile -t opt_outs < <(yq -r ".targets[$i].opt_outs[]?" "$TARGETS_FILE")

  all_templates=("${templates[@]}" "${optional_features[@]}")

  for template_id in "${all_templates[@]}"; do
    [[ -z "$template_id" || "$template_id" == "null" ]] && continue

    relative_path="$(lookup_template_path "$template_id")"
    if [[ -z "$relative_path" || "$relative_path" == "null" ]]; then
      echo "Skipping unknown template id: $template_id"
      continue
    fi

    skip_path="false"
    for opted_path in "${opt_outs[@]}"; do
      if [[ "$relative_path" == "$opted_path" ]]; then
        skip_path="true"
        break
      fi
    done

    if [[ "$skip_path" == "true" ]]; then
      echo "Opted-out path for $repo: $relative_path"
      continue
    fi

    if ! copy_template "$repo_dir" "$template_id"; then
      continue
    fi

    source_ref="$(lookup_template_ref "$template_id")"
    refs+="- ${template_id}: ${source_ref}"$'\n'
  done

  if [[ -z "$(git status --porcelain)" ]]; then
    echo "No changes for $repo"
    popd >/dev/null
    ((skipped+=1))
    continue
  fi

  git add -A
  git commit -m "chore: sync ASDEV Level 0 templates" >/dev/null

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "DRY_RUN=true -> skipping push and PR for $repo"
    popd >/dev/null
    ((success+=1))
    continue
  fi

  git push -u origin "$branch_name" >/dev/null

  pr_body_file="$work_root/pr-body-${i}.md"
  create_pr_body "$repo" "$refs" > "$pr_body_file"

  labels_args=()
  mapfile -t labels < <(yq -r ".targets[$i].labels[]?" "$TARGETS_FILE")
  for label in "${labels[@]}"; do
    [[ -z "$label" || "$label" == "null" ]] && continue
    labels_args+=(--label "$label")
  done

  pr_created="false"
  if retry_cmd "$RETRY_ATTEMPTS" "$GH_BIN" pr create \
    --title "chore: ASDEV Level 0 sync" \
    --body-file "$pr_body_file" \
    --base "$default_branch" \
    "${labels_args[@]}" >/dev/null; then
    pr_created="true"
  elif [[ "${#labels_args[@]}" -gt 0 ]]; then
    echo "PR create with labels failed for $repo. Retrying without labels..."
    if retry_cmd "$RETRY_ATTEMPTS" "$GH_BIN" pr create \
      --title "chore: ASDEV Level 0 sync" \
      --body-file "$pr_body_file" \
      --base "$default_branch" >/dev/null; then
      pr_created="true"
    fi
  fi

  if [[ "$pr_created" == "true" ]]; then
    echo "PR created for $repo"
    ((success+=1))
  else
    echo "Failed to create PR for $repo"
    ((failed+=1))
  fi

  popd >/dev/null
done

echo "Sync summary -> success: $success, failed: $failed, skipped: $skipped"
if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
