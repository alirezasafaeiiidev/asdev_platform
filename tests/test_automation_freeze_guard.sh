#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

flag_file="${WORK_DIR}/FREEZE_AUTOMATION"

active_out="$({
  set +e
  FREEZE_FLAG_FILE="${flag_file}" WEEKLY_FREEZE_DOW="sun" bash "${ROOT_DIR}/scripts/automation-freeze-guard.sh"
  echo "EC:$?"
} 2>&1)"
if [[ "${active_out}" != *"freeze_inactive"* ]] || [[ "${active_out}" != *"EC:0"* ]]; then
  echo "Expected inactive freeze state" >&2
  exit 1
fi

touch "${flag_file}"
file_out="$({
  set +e
  FREEZE_FLAG_FILE="${flag_file}" WEEKLY_FREEZE_DOW="sun" bash "${ROOT_DIR}/scripts/automation-freeze-guard.sh"
  echo "EC:$?"
} 2>&1)"
if [[ "${file_out}" != *"freeze_active:file"* ]] || [[ "${file_out}" != *"EC:10"* ]]; then
  echo "Expected file-based freeze state" >&2
  exit 1
fi

window_out="$({
  set +e
  FREEZE_FLAG_FILE="${WORK_DIR}/does-not-exist" WEEKLY_FREEZE_DOW="$(date -u +%a | tr '[:upper:]' '[:lower:]')" WEEKLY_FREEZE_START="00:00" WEEKLY_FREEZE_END="23:59" bash "${ROOT_DIR}/scripts/automation-freeze-guard.sh"
  echo "EC:$?"
} 2>&1)"
if [[ "${window_out}" != *"freeze_active:window"* ]] || [[ "${window_out}" != *"EC:10"* ]]; then
  echo "Expected window-based freeze state" >&2
  exit 1
fi

echo "automation freeze guard checks passed."
