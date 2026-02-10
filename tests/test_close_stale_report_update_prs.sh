#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT
NOW_EPOCH="$(date -u -d '2026-02-10T00:00:00Z' +%s 2>/dev/null || date -u -jf "%Y-%m-%dT%H:%M:%SZ" '2026-02-10T00:00:00Z' +%s)"

FAKE_BIN="${WORK_DIR}/fakebin"
mkdir -p "$FAKE_BIN"

CLOSE_LOG="${WORK_DIR}/close.log"
SUMMARY_LOG="${WORK_DIR}/summary.log"

cat > "${FAKE_BIN}/gh" <<'GH'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "pr" && "${2:-}" == "list" ]]; then
  cat <<'TSV'
42	2026-02-09T22:00:00Z	https://example.invalid/pr/42
41	2026-02-09T20:30:00Z	https://example.invalid/pr/41
40	2026-02-07T10:00:00Z	https://example.invalid/pr/40
TSV
  exit 0
fi

if [[ "${1:-}" == "pr" && "${2:-}" == "close" ]]; then
  echo "$*" >> "${CLOSE_LOG_PATH:?}"
  exit 0
fi

exit 0
GH
chmod +x "${FAKE_BIN}/gh"

(
  cd "$ROOT_DIR"
  CLOSE_LOG_PATH="$CLOSE_LOG" \
  REPORT_UPDATE_PR_SUMMARY_FILE="$SUMMARY_LOG" \
  REPORT_UPDATE_PR_STALE_HOURS=24 \
  REPORT_UPDATE_PR_NOW_EPOCH="${NOW_EPOCH}" \
  PATH="$FAKE_BIN:${PATH}" \
  bash scripts/close-stale-report-update-prs.sh "owner/repo" "chore/reports-docs-update"
)

grep -q 'pr close 41' "$CLOSE_LOG" || {
  echo "Expected close of superseded PR #41" >&2
  exit 1
}

grep -q 'pr close 40' "$CLOSE_LOG" || {
  echo "Expected close of stale PR #40" >&2
  exit 1
}

if grep -q 'pr close 42' "$CLOSE_LOG"; then
  echo "Did not expect close of newest PR #42" >&2
  exit 1
fi

grep -q '^closed_superseded=1$' "$SUMMARY_LOG" || {
  echo "Expected summary closed_superseded=1" >&2
  exit 1
}

grep -q '^closed_stale=1$' "$SUMMARY_LOG" || {
  echo "Expected summary closed_stale=1" >&2
  exit 1
}

DRY_RUN_LOG="${WORK_DIR}/dry-run.log"
DRY_RUN_SUMMARY_LOG="${WORK_DIR}/dry-run-summary.log"
close_lines_before="$(wc -l < "$CLOSE_LOG")"
(
  cd "$ROOT_DIR"
  CLOSE_LOG_PATH="$CLOSE_LOG" \
  REPORT_UPDATE_PR_SUMMARY_FILE="$DRY_RUN_SUMMARY_LOG" \
  REPORT_UPDATE_PR_STALE_HOURS=24 \
  REPORT_UPDATE_PR_STALE_DRY_RUN=true \
  REPORT_UPDATE_PR_NOW_EPOCH="${NOW_EPOCH}" \
  PATH="$FAKE_BIN:${PATH}" \
  bash scripts/close-stale-report-update-prs.sh "owner/repo" "chore/reports-docs-update" > "$DRY_RUN_LOG"
)
close_lines_after="$(wc -l < "$CLOSE_LOG")"

grep -q 'DRY_RUN superseded PR candidate #41' "$DRY_RUN_LOG" || {
  echo "Expected dry-run superseded candidate for #41" >&2
  exit 1
}

grep -q 'DRY_RUN stale PR candidate #40' "$DRY_RUN_LOG" || {
  echo "Expected dry-run stale candidate for #40" >&2
  exit 1
}

if [[ "$close_lines_after" -ne "$close_lines_before" ]]; then
  echo "Dry-run must not close PRs" >&2
  exit 1
fi

grep -q '^dry_run_enabled=true$' "$DRY_RUN_SUMMARY_LOG" || {
  echo "Expected summary dry_run_enabled=true" >&2
  exit 1
}

grep -q '^dry_run_candidates_superseded=1$' "$DRY_RUN_SUMMARY_LOG" || {
  echo "Expected summary dry_run_candidates_superseded=1" >&2
  exit 1
}

grep -q '^dry_run_candidates_stale=1$' "$DRY_RUN_SUMMARY_LOG" || {
  echo "Expected summary dry_run_candidates_stale=1" >&2
  exit 1
}

echo "close stale report update PR checks passed."
