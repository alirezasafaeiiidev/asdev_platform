#!/usr/bin/env bash
set -euo pipefail

TEMPLATES_FILE="${1:-platform/repo-templates/templates.yaml}"
TEMPLATES_ROOT="${2:-platform/repo-templates}"
OUTPUT_FILE="${3:-sync/divergence-report.combined.csv}"
TARGET_GLOB="${4:-sync/targets*.yaml}"
ERRORS_OUTPUT_FILE="${5:-}"

resolve_path() {
  local path_value="$1"
  if [[ "$path_value" = /* ]]; then
    printf "%s\n" "$path_value"
  else
    printf "%s/%s\n" "$(pwd)" "$path_value"
  fi
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require_cmd bash
require_cmd find

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ASDEV_CLONE_PARALLELISM="${ASDEV_CLONE_PARALLELISM:-3}"
ASDEV_HEAVY_JOB_PARALLELISM="${ASDEV_HEAVY_JOB_PARALLELISM:-2}"
ASDEV_WORKER_CAP="${ASDEV_WORKER_CAP:-6}"
ASDEV_E2E_WORKERS="${ASDEV_E2E_WORKERS:-1}"
TARGET_FILE_PARALLELISM="${TARGET_FILE_PARALLELISM:-$ASDEV_HEAVY_JOB_PARALLELISM}"
if ! [[ "$TARGET_FILE_PARALLELISM" =~ ^[0-9]+$ ]] || [[ "$TARGET_FILE_PARALLELISM" -lt 1 ]]; then
  TARGET_FILE_PARALLELISM=1
fi
echo "Resource policy (combined report): clone_parallelism=${ASDEV_CLONE_PARALLELISM} heavy_job_parallelism=${ASDEV_HEAVY_JOB_PARALLELISM} worker_cap=${ASDEV_WORKER_CAP} e2e_workers=${ASDEV_E2E_WORKERS} target_file_parallelism=${TARGET_FILE_PARALLELISM}"

TEMPLATES_FILE="$(resolve_path "$TEMPLATES_FILE")"
TEMPLATES_ROOT="$(resolve_path "$TEMPLATES_ROOT")"
OUTPUT_FILE="$(resolve_path "$OUTPUT_FILE")"
if [[ -n "$ERRORS_OUTPUT_FILE" ]]; then
  ERRORS_OUTPUT_FILE="$(resolve_path "$ERRORS_OUTPUT_FILE")"
else
  ERRORS_OUTPUT_FILE="${OUTPUT_FILE%.csv}.errors.csv"
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"
mkdir -p "$(dirname "$ERRORS_OUTPUT_FILE")"

echo "target_file,repo,template_id,expected_version,detected_version,mode,source_ref,status,last_checked_at" > "$OUTPUT_FILE"
echo "target_file,repo,error_fingerprint,last_checked_at" > "$ERRORS_OUTPUT_FILE"

target_glob_abs="$TARGET_GLOB"
if [[ "$target_glob_abs" != /* ]]; then
  target_glob_abs="$(pwd)/${target_glob_abs#./}"
fi

shopt -s nullglob
expanded_target_files=( $target_glob_abs )
shopt -u nullglob

target_files=()
for file in "${expanded_target_files[@]}"; do
  [[ -f "$file" ]] || continue
  [[ "$(basename "$file")" == "targets.example.yaml" ]] && continue
  target_files+=("$file")
done

if [[ "${#target_files[@]}" -gt 0 ]]; then
  mapfile -t target_files < <(printf '%s\n' "${target_files[@]}" | sort -u)
fi

if [[ "${#target_files[@]}" -eq 0 ]]; then
  echo "No target files found for glob: ${TARGET_GLOB}"
  exit 0
fi

tmp_root="$(mktemp -d)"
cleanup_tmp_root() { rm -rf "$tmp_root"; }
trap cleanup_tmp_root EXIT

pids=()
for i in "${!target_files[@]}"; do
  target_file="${target_files[$i]}"
  (
    tmp_csv="$tmp_root/report_${i}.csv"
    tmp_errors_csv="$tmp_root/errors_${i}.csv"
    bash "${ROOT_DIR}/platform/scripts/divergence-report.sh" "$target_file" "$TEMPLATES_FILE" "$TEMPLATES_ROOT" "$tmp_csv" "$tmp_errors_csv"
    printf '%s\n' "$target_file" > "$tmp_root/target_${i}.txt"
  ) &
  pids+=("$!")

  while [[ "$(jobs -rp | wc -l | tr -d ' ')" -ge "$TARGET_FILE_PARALLELISM" ]]; do
    wait -n
  done
done

for pid in "${pids[@]}"; do
  wait "$pid"
done

for i in "${!target_files[@]}"; do
  target_file="$(cat "$tmp_root/target_${i}.txt")"
  tmp_csv="$tmp_root/report_${i}.csv"
  tmp_errors_csv="$tmp_root/errors_${i}.csv"
  if [[ -s "$tmp_csv" ]]; then
    tail -n +2 "$tmp_csv" | awk -F, -v tf="$(basename "$target_file")" 'BEGIN{OFS=","} {print tf,$0}' >> "$OUTPUT_FILE"
  fi
  if [[ -s "$tmp_errors_csv" ]]; then
    tail -n +2 "$tmp_errors_csv" | awk -F, -v tf="$(basename "$target_file")" 'BEGIN{OFS=","} {print tf,$0}' >> "$ERRORS_OUTPUT_FILE"
  fi
done

echo "Combined divergence report generated: $OUTPUT_FILE"
echo "Combined divergence error fingerprint report generated: $ERRORS_OUTPUT_FILE"
