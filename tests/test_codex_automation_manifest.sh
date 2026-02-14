#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="${ROOT_DIR}/ops/automation/codex-automation.yaml"

[[ -f "${manifest}" ]] || {
  echo "Missing ${manifest}" >&2
  exit 1
}

grep -q '^manifest_ref: ops/automation/execution-manifest.yaml$' "${manifest}" || {
  echo "manifest_ref is missing or incorrect" >&2
  exit 1
}

grep -q '^  branch_sync:$' "${manifest}" || {
  echo "branch_sync policy block missing" >&2
  exit 1
}

grep -q '^  auth:$' "${manifest}" || {
  echo "auth policy block missing" >&2
  exit 1
}

grep -q '^  runtime_freeze:$' "${manifest}" || {
  echo "runtime_freeze policy block missing" >&2
  exit 1
}

echo "codex automation manifest checks passed."
