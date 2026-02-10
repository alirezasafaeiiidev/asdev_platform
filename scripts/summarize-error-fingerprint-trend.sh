#!/usr/bin/env bash
set -euo pipefail

TREND_FILE="${1:-sync/divergence-report.combined.errors.trend.csv}"
TOP_N="${2:-3}"

if [[ ! -f "$TREND_FILE" ]]; then
  echo "Missing trend file: $TREND_FILE" >&2
  exit 1
fi

csv_col_idx() {
  local file="$1"
  local name="$2"
  awk -F, -v n="$name" '
    NR==1 {
      for (i=1; i<=NF; i++) {
        if ($i == n) {
          print i
          exit
        }
      }
    }
  ' "$file"
}

echo "## Error Fingerprint Delta Summary"
echo ""
echo "- Source: \
  ${TREND_FILE}"
echo ""

total_rows="$(awk -F, 'NR>1 {c++} END {print c+0}' "$TREND_FILE")"
if [[ "$total_rows" -eq 0 ]]; then
  echo "No fingerprint rows available."
  exit 0
fi

fp_idx="$(csv_col_idx "$TREND_FILE" "error_fingerprint")"
prev_idx="$(csv_col_idx "$TREND_FILE" "previous")"
curr_idx="$(csv_col_idx "$TREND_FILE" "current")"
delta_idx="$(csv_col_idx "$TREND_FILE" "delta")"

if [[ -z "$fp_idx" || -z "$prev_idx" || -z "$curr_idx" || -z "$delta_idx" ]]; then
  echo "Missing required trend columns in: $TREND_FILE" >&2
  exit 1
fi

mapfile -t positive < <(awk -F, -v fi="$fp_idx" -v pi="$prev_idx" -v ci="$curr_idx" -v di="$delta_idx" 'NR>1 && ($di+0)>0 {print $fi "," $pi "," $ci "," $di}' "$TREND_FILE" | sort -t, -k4,4nr | head -n "$TOP_N")
mapfile -t negative < <(awk -F, -v fi="$fp_idx" -v pi="$prev_idx" -v ci="$curr_idx" -v di="$delta_idx" 'NR>1 && ($di+0)<0 {print $fi "," $pi "," $ci "," $di}' "$TREND_FILE" | sort -t, -k4,4n | head -n "$TOP_N")

print_table() {
  local title="$1"
  shift
  local rows=("$@")

  echo "### ${title}"
  echo ""
  echo "| Fingerprint | Previous | Current | Delta |"
  echo "|---|---:|---:|---:|"

  if [[ "${#rows[@]}" -eq 0 ]]; then
    echo "| none | 0 | 0 | 0 |"
  else
    local row fp prev curr delta
    for row in "${rows[@]}"; do
      IFS=',' read -r fp prev curr delta <<< "$row"
      echo "| ${fp} | ${prev} | ${curr} | ${delta} |"
    done
  fi
  echo ""
}

print_table "Top Increasing Fingerprints" "${positive[@]}"
print_table "Top Decreasing Fingerprints" "${negative[@]}"
