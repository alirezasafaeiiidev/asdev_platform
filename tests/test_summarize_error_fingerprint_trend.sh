#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

trend_file="${WORK_DIR}/trend.csv"
output_file="${WORK_DIR}/summary.md"

cat > "${trend_file}" <<'CSV'
error_fingerprint,previous,current,delta
tls_error,2,5,3
timeout,4,1,-3
http_502,1,2,1
unknown_transient,1,0,-1
CSV

(
  cd "${ROOT_DIR}"
  bash scripts/summarize-error-fingerprint-trend.sh "${trend_file}" 2 > "${output_file}"
)

grep -q '^## Error Fingerprint Delta Summary$' "${output_file}" || {
  echo "Missing summary title" >&2
  exit 1
}

grep -q '^### Top Increasing Fingerprints$' "${output_file}" || {
  echo "Missing increasing section" >&2
  exit 1
}

grep -q '^| tls_error | 2 | 5 | 3 |$' "${output_file}" || {
  echo "Missing tls_error positive row" >&2
  exit 1
}

grep -q '^| http_502 | 1 | 2 | 1 |$' "${output_file}" || {
  echo "Missing http_502 positive row" >&2
  exit 1
}

grep -q '^### Top Decreasing Fingerprints$' "${output_file}" || {
  echo "Missing decreasing section" >&2
  exit 1
}

grep -q '^| timeout | 4 | 1 | -3 |$' "${output_file}" || {
  echo "Missing timeout negative row" >&2
  exit 1
}

grep -q '^| unknown_transient | 1 | 0 | -1 |$' "${output_file}" || {
  echo "Missing unknown_transient negative row" >&2
  exit 1
}

empty_trend="${WORK_DIR}/empty-trend.csv"
cat > "${empty_trend}" <<'CSV'
error_fingerprint,previous,current,delta
CSV

(
  cd "${ROOT_DIR}"
  bash scripts/summarize-error-fingerprint-trend.sh "${empty_trend}" > "${WORK_DIR}/empty-summary.md"
)

grep -q '^No fingerprint rows available\.$' "${WORK_DIR}/empty-summary.md" || {
  echo "Missing stable no-row message" >&2
  exit 1
}

echo "error fingerprint trend summary checks passed."
