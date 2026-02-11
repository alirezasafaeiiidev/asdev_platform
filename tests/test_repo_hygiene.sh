#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

mkdir -p "${WORK_DIR}/a/__pycache__"
mkdir -p "${WORK_DIR}/empty-dir"
touch "${WORK_DIR}/a/__pycache__/x.pyc"
touch "${WORK_DIR}/.DS_Store"

if bash "${ROOT_DIR}/scripts/repo-hygiene.sh" check "${WORK_DIR}" >/dev/null 2>&1; then
  echo "expected repo hygiene check to fail on dirty workspace" >&2
  exit 1
fi

bash "${ROOT_DIR}/scripts/repo-hygiene.sh" fix "${WORK_DIR}" >/dev/null
bash "${ROOT_DIR}/scripts/repo-hygiene.sh" check "${WORK_DIR}" >/dev/null

echo "repo hygiene script works as expected."
