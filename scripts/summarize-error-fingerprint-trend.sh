#!/usr/bin/env bash
set -euo pipefail

TREND_FILE="${1:-sync/divergence-report.combined.errors.trend.csv}"
TOP_N="${2:-3}"

if [[ ! -f "$TREND_FILE" ]]; then
  echo "Missing trend file: $TREND_FILE" >&2
  exit 1
fi

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

mapfile -t positive < <(awk -F, 'NR>1 && ($4+0)>0 {print $0}' "$TREND_FILE" | sort -t, -k4,4nr | head -n "$TOP_N")
mapfile -t negative < <(awk -F, 'NR>1 && ($4+0)<0 {print $0}' "$TREND_FILE" | sort -t, -k4,4n | head -n "$TOP_N")

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
