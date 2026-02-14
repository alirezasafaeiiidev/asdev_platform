#!/usr/bin/env bash
set -euo pipefail

STRICT_PAT_FORBID="${STRICT_PAT_FORBID:-true}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh_missing"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "gh_auth_missing"
  exit 1
fi

if [[ "${STRICT_PAT_FORBID}" == "true" ]]; then
  if [[ -n "${GITHUB_TOKEN:-}" || -n "${GH_TOKEN:-}" ]]; then
    echo "pat_env_detected"
    exit 1
  fi
fi

echo "gh_auth_ok"
