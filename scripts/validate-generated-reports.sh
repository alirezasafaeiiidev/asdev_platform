#!/usr/bin/env bash
set -euo pipefail

COMBINED_FILE="${1:-sync/divergence-report.combined.csv}"
ERRORS_FILE="${2:-sync/divergence-report.combined.errors.csv}"
TREND_FILE="${3:-sync/divergence-report.combined.errors.trend.csv}"

validate_file() {
  local file="$1"
  local expected_header="$2"
  local expected_columns="$3"

  if [[ ! -f "$file" ]]; then
    echo "Missing generated report file: $file" >&2
    exit 1
  fi

  local actual_header
  actual_header="$(head -n 1 "$file")"
  if [[ "$actual_header" != "$expected_header" ]]; then
    echo "Schema header mismatch in $file" >&2
    echo "Expected: $expected_header" >&2
    echo "Actual:   $actual_header" >&2
    exit 1
  fi

  if ! awk -F, -v n="$expected_columns" 'NR>1 && NF!=n {print "Invalid column count at line " NR " in " FILENAME ": expected " n ", got " NF > "/dev/stderr"; exit 1}' "$file"; then
    exit 1
  fi
}

validate_file "$COMBINED_FILE" "target_file,repo,template_id,expected_version,detected_version,mode,source_ref,status,last_checked_at" 9
validate_file "$ERRORS_FILE" "target_file,repo,error_fingerprint,last_checked_at" 4
validate_file "$TREND_FILE" "error_fingerprint,previous,current,delta" 4

echo "Generated report schema checks passed."
