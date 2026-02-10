#!/usr/bin/env bash
set -euo pipefail

PREV_FILE="${1:-sync/divergence-report.combined.errors.previous.csv}"
CURR_FILE="${2:-sync/divergence-report.combined.errors.csv}"
OUTPUT_FILE="${3:-sync/divergence-report.combined.errors.trend.csv}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/scripts/csv-utils.sh"

mkdir -p "$(dirname "${OUTPUT_FILE}")"
echo "error_fingerprint,previous,current,delta" > "${OUTPUT_FILE}"

if [[ ! -f "${CURR_FILE}" ]]; then
  echo "Missing current errors file: ${CURR_FILE}" >&2
  exit 1
fi

extract_column_values() {
  local file="$1"
  local name="$2"
  if [[ ! -f "$file" ]]; then
    return
  fi
  local idx
  idx="$(csv_col_idx "$file" "$name")"
  if [[ -z "$idx" ]]; then
    return
  fi
  awk -F, -v i="$idx" 'NR>1 {print $i}' "$file"
}

mapfile -t fingerprints < <(
  {
    extract_column_values "${PREV_FILE}" "error_fingerprint"
    extract_column_values "${CURR_FILE}" "error_fingerprint"
  } | sed '/^$/d' | sort -u
)

if [[ "${#fingerprints[@]}" -eq 0 ]]; then
  echo "none,0,0,0" >> "${OUTPUT_FILE}"
  echo "Generated empty fingerprint trend: ${OUTPUT_FILE}"
  exit 0
fi

count_for() {
  local file="$1"
  local fingerprint="$2"
  if [[ ! -f "$file" ]]; then
    echo 0
    return
  fi
  local idx
  idx="$(csv_col_idx "$file" "error_fingerprint")"
  if [[ -z "$idx" ]]; then
    echo 0
    return
  fi
  awk -F, -v fp="$fingerprint" -v i="$idx" 'NR>1 && $i==fp {c++} END {print c+0}' "$file"
}

for fp in "${fingerprints[@]}"; do
  prev="$(count_for "${PREV_FILE}" "${fp}")"
  curr="$(count_for "${CURR_FILE}" "${fp}")"
  delta=$((curr - prev))
  echo "${fp},${prev},${curr},${delta}" >> "${OUTPUT_FILE}"
done

echo "Generated fingerprint trend: ${OUTPUT_FILE}"
