#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_DIR="${LOG_DIR:-${PLATFORM_ROOT}/var/autopilot}"
PID_FILE="${LOG_DIR}/autopilot.pid"
SERVICE_NAME="${SERVICE_NAME:-asdev-autopilot.service}"
USER_SERVICE_FILE="${HOME}/.config/systemd/user/${SERVICE_NAME}"

if command -v systemctl >/dev/null 2>&1 && [[ -f "${USER_SERVICE_FILE}" ]]; then
  if systemctl --user is-active --quiet "${SERVICE_NAME}"; then
    systemctl --user stop "${SERVICE_NAME}"
    echo "autopilot stopped via systemd: ${SERVICE_NAME}"
  fi
fi

if [[ ! -f "${PID_FILE}" ]]; then
  echo "autopilot is not running"
  exit 0
fi

PID="$(cat "${PID_FILE}")"
if kill "${PID}" >/dev/null 2>&1; then
  echo "autopilot stopped: pid=${PID}"
  rm -f "${PID_FILE}"
else
  echo "failed to stop autopilot pid=${PID}"
  exit 1
fi
