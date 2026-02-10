#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output="$(
  cd "${ROOT_DIR}"
  GH_FORCE_MISSING=true make --no-print-directory ci-last-run-compact
)"

if [[ "${output}" != $'n/a\tn/a' ]]; then
  echo "Expected ci-last-run-compact fallback to output 'n/a<TAB>n/a'" >&2
  exit 1
fi

echo "ci-last-run-compact fallback checks passed."
