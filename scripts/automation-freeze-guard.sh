#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
FREEZE_FLAG_FILE="${FREEZE_FLAG_FILE:-${REPO_ROOT}/ops/automation/FREEZE_AUTOMATION}"
WEEKLY_FREEZE_DOW="${WEEKLY_FREEZE_DOW:-sat}"
WEEKLY_FREEZE_START="${WEEKLY_FREEZE_START:-16:00}"
WEEKLY_FREEZE_END="${WEEKLY_FREEZE_END:-20:00}"

if [[ -f "${FREEZE_FLAG_FILE}" ]]; then
  echo "freeze_active:file:${FREEZE_FLAG_FILE}"
  exit 10
fi

now_day="$(date -u +%a | tr '[:upper:]' '[:lower:]')"
now_min="$((10#$(date -u +%H) * 60 + 10#$(date -u +%M)))"
start_min="$((10#${WEEKLY_FREEZE_START%:*} * 60 + 10#${WEEKLY_FREEZE_START#*:}))"
end_min="$((10#${WEEKLY_FREEZE_END%:*} * 60 + 10#${WEEKLY_FREEZE_END#*:}))"

if [[ "${now_day}" == "${WEEKLY_FREEZE_DOW}" ]] && (( now_min >= start_min && now_min < end_min )); then
  echo "freeze_active:window:${WEEKLY_FREEZE_DOW} ${WEEKLY_FREEZE_START}-${WEEKLY_FREEZE_END} UTC"
  exit 10
fi

echo "freeze_inactive"
