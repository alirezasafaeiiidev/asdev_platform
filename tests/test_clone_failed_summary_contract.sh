#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

REPORT_CSV="${WORK_DIR}/combined.csv"
cat > "${REPORT_CSV}" <<'CSV'
target_file,repo,template_id,expected_version,detected_version,mode,source_ref,last_checked_at,status
targets.yaml,example/a,level0,1.0.0,missing,required,ref,2026-02-10T00:00:00Z,clone_failed
targets.yaml,example/b,level0,1.0.0,1.0.0,required,ref,2026-02-10T00:00:00Z,aligned
CSV

output="$(bash "${ROOT_DIR}/scripts/summarize-clone-failed.sh" "${REPORT_CSV}")"

echo "${output}" | grep -q '^## clone_failed Repositories$' || {
  echo "Missing clone_failed summary heading" >&2
  exit 1
}

echo "${output}" | grep -q '^- count: 1$' || {
  echo "Missing clone_failed summary count" >&2
  exit 1
}

echo "clone_failed summary contract checks passed."
