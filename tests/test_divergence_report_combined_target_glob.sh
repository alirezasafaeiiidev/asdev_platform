#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
YQ_BIN="$("${ROOT_DIR}/scripts/ensure-yq.sh")"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

FAKE_BIN="${WORK_DIR}/fakebin"
FAKE_GH_ROOT="${WORK_DIR}/fake-gh-repos"
mkdir -p "${FAKE_BIN}" "${FAKE_GH_ROOT}" "${WORK_DIR}/sync"

cat > "${FAKE_BIN}/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "repo" && "${2:-}" == "clone" ]]; then
  repo="${3:-}"
  dest="${4:-}"
  key="${repo//\//__}"
  cp -a "${FAKE_GH_ROOT}/${key}" "${dest}"
  exit 0
fi

exit 0
GH
chmod +x "${FAKE_BIN}/gh"

for key in local__repo-a local__repo-b; do
  repo_dir="${FAKE_GH_ROOT}/${key}"
  mkdir -p "${repo_dir}"
  (
    cd "${repo_dir}"
    git init -q
    git checkout -b main >/dev/null
    git config user.name "asdev-test"
    git config user.email "asdev-test@example.com"
    mkdir -p .github
    cp "${ROOT_DIR}/platform/repo-templates/.github/pull_request_template.md" .github/pull_request_template.md
    git add .
    git commit -q -m "test: init"
  )
done

cat > "${WORK_DIR}/sync/targets.alpha.yaml" <<'YAML'
targets:
  - repo: local/repo-a
    default_branch: main
    templates:
      - pr-template
    optional_features: []
    opt_outs: []
    labels: []
YAML

cat > "${WORK_DIR}/sync/targets.beta.yaml" <<'YAML'
targets:
  - repo: local/repo-b
    default_branch: main
    templates:
      - pr-template
    optional_features: []
    opt_outs: []
    labels: []
YAML

(
  cd "${WORK_DIR}"
  export FAKE_GH_ROOT
  PATH="${FAKE_BIN}:$(dirname "${YQ_BIN}"):${PATH}" \
  bash "${ROOT_DIR}/platform/scripts/divergence-report-combined.sh" \
    "${ROOT_DIR}/platform/repo-templates/templates.yaml" \
    "${ROOT_DIR}/platform/repo-templates" \
    "${WORK_DIR}/sync/divergence-report.combined.csv" \
    "sync/targets.alpha.yaml" \
    "${WORK_DIR}/sync/divergence-report.combined.errors.csv"
)

rows="$(tail -n +2 "${WORK_DIR}/sync/divergence-report.combined.csv" | wc -l)"
if [[ "$rows" -ne 1 ]]; then
  echo "Expected one row for single target glob, got ${rows}" >&2
  exit 1
fi

grep -q '^targets.alpha.yaml,' "${WORK_DIR}/sync/divergence-report.combined.csv" || {
  echo "Expected only targets.alpha.yaml rows in combined output" >&2
  exit 1
}

if grep -q '^targets.beta.yaml,' "${WORK_DIR}/sync/divergence-report.combined.csv"; then
  echo "Unexpected targets.beta.yaml rows for alpha-only glob" >&2
  exit 1
fi

echo "combined divergence target glob checks passed."
