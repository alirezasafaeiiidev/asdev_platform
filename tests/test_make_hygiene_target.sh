#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

grep -q '^hygiene:' "${ROOT_DIR}/Makefile" || {
  echo "Missing hygiene make target" >&2
  exit 1
}

if ! make -C "${ROOT_DIR}" --no-print-directory hygiene >/dev/null; then
  echo "make hygiene failed" >&2
  exit 1
fi

echo "make hygiene target checks passed."
