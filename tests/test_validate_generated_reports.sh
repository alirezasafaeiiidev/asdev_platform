#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

combined_ok="${WORK_DIR}/combined.csv"
errors_ok="${WORK_DIR}/errors.csv"
trend_ok="${WORK_DIR}/trend.csv"

cat > "${combined_ok}" <<'CSV'
target_file,repo,template_id,expected_version,detected_version,mode,source_ref,status,last_checked_at
a.yaml,org/repo,pr-template,1.0.0,1.0.0,required,ref,aligned,2026-02-09T00:00:00Z
CSV

cat > "${errors_ok}" <<'CSV'
target_file,repo,error_fingerprint,last_checked_at
a.yaml,org/repo,tls_error,2026-02-09T00:00:00Z
CSV

cat > "${trend_ok}" <<'CSV'
error_fingerprint,previous,current,delta
tls_error,1,2,1
CSV

(
  cd "${ROOT_DIR}"
  bash scripts/validate-generated-reports.sh "${combined_ok}" "${errors_ok}" "${trend_ok}"
)

trend_bad="${WORK_DIR}/trend-bad.csv"
cat > "${trend_bad}" <<'CSV'
error_fingerprint,previous,current
missing_delta,1,2
CSV

set +e
(
  cd "${ROOT_DIR}"
  bash scripts/validate-generated-reports.sh "${combined_ok}" "${errors_ok}" "${trend_bad}"
) >"${WORK_DIR}/bad.out" 2>"${WORK_DIR}/bad.err"
status=$?
set -e

if [[ "$status" -eq 0 ]]; then
  echo "Expected schema validation failure for malformed trend header" >&2
  exit 1
fi

grep -q 'Schema header mismatch' "${WORK_DIR}/bad.err" || {
  echo "Expected schema header mismatch error" >&2
  exit 1
}

echo "generated report schema validation checks passed."
