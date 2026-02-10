#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-${GITHUB_REPOSITORY:-}}"
HEAD_BRANCH="${2:-chore/reports-docs-update}"
SLA_HOURS="${REPORT_UPDATE_PR_STALE_HOURS:-48}"
DRY_RUN="${REPORT_UPDATE_PR_STALE_DRY_RUN:-false}"
SUMMARY_FILE="${REPORT_UPDATE_PR_SUMMARY_FILE:-}"

if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <repo> [head_branch]" >&2
  exit 2
fi

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

to_epoch() {
  local ts="$1"
  date -u -d "$ts" +%s 2>/dev/null || date -u -jf "%Y-%m-%dT%H:%M:%SZ" "$ts" +%s
}

require_cmd gh
require_cmd date
require_cmd awk

now_epoch="${REPORT_UPDATE_PR_NOW_EPOCH:-$(date -u +%s)}"

mapfile -t prs < <(
  gh pr list \
    --repo "$REPO" \
    --state open \
    --head "$HEAD_BRANCH" \
    --json number,updatedAt,url \
    --jq 'sort_by(.updatedAt) | reverse | .[] | [.number, .updatedAt, .url] | @tsv'
)

if [[ "${#prs[@]}" -eq 0 ]]; then
  if [[ -n "$SUMMARY_FILE" ]]; then
    {
      echo "total_open=0"
      echo "kept_pr="
      echo "closed_superseded=0"
      echo "closed_stale=0"
      echo "dry_run_candidates_superseded=0"
      echo "dry_run_candidates_stale=0"
      echo "dry_run_enabled=${DRY_RUN}"
    } > "$SUMMARY_FILE"
  fi
  echo "No open report update PRs."
  exit 0
fi

keep_number="$(awk -F$'\t' 'NR==1 {print $1}' <<< "${prs[0]}")"
closed_superseded=0
closed_stale=0
dry_run_candidates_superseded=0
dry_run_candidates_stale=0
echo "Keeping newest report update PR #${keep_number} open."

if [[ "${#prs[@]}" -eq 1 ]]; then
  if [[ -n "$SUMMARY_FILE" ]]; then
    {
      echo "total_open=1"
      echo "kept_pr=${keep_number}"
      echo "closed_superseded=0"
      echo "closed_stale=0"
      echo "dry_run_candidates_superseded=0"
      echo "dry_run_candidates_stale=0"
      echo "dry_run_enabled=${DRY_RUN}"
    } > "$SUMMARY_FILE"
  fi
  exit 0
fi

for row in "${prs[@]:1}"; do
  pr_number="$(awk -F$'\t' '{print $1}' <<< "$row")"
  updated_at="$(awk -F$'\t' '{print $2}' <<< "$row")"
  pr_url="$(awk -F$'\t' '{print $3}' <<< "$row")"

  updated_epoch="$(to_epoch "$updated_at")"
  age_hours="$(( (now_epoch - updated_epoch) / 3600 ))"

  close_reason="superseded"
  comment_body="Auto-closing superseded report update PR. Keeping newest report update PR #${keep_number} active."
  if [[ "$age_hours" -ge "$SLA_HOURS" ]]; then
    close_reason="stale"
    comment_body="Auto-closing stale report update PR (>${SLA_HOURS}h without update). Keeping newest report update PR #${keep_number} active."
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    if [[ "$close_reason" == "stale" ]]; then
      dry_run_candidates_stale=$((dry_run_candidates_stale + 1))
    else
      dry_run_candidates_superseded=$((dry_run_candidates_superseded + 1))
    fi
    echo "DRY_RUN ${close_reason} PR candidate #${pr_number} (${pr_url}) age_hours=${age_hours} threshold=${SLA_HOURS}"
    continue
  fi

  gh pr close "$pr_number" --repo "$REPO" --comment "$comment_body"
  if [[ "$close_reason" == "stale" ]]; then
    closed_stale=$((closed_stale + 1))
  else
    closed_superseded=$((closed_superseded + 1))
  fi
  echo "Closed ${close_reason} report update PR #${pr_number} (${pr_url})"
done

if [[ -n "$SUMMARY_FILE" ]]; then
  {
    echo "total_open=${#prs[@]}"
    echo "kept_pr=${keep_number}"
    echo "closed_superseded=${closed_superseded}"
    echo "closed_stale=${closed_stale}"
    echo "dry_run_candidates_superseded=${dry_run_candidates_superseded}"
    echo "dry_run_candidates_stale=${dry_run_candidates_stale}"
    echo "dry_run_enabled=${DRY_RUN}"
  } > "$SUMMARY_FILE"
fi
