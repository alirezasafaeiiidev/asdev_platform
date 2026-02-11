#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAKEFILE="${ROOT_DIR}/Makefile"

grep -q '^verify-hub:' "${MAKEFILE}" || {
  echo "Missing verify-hub target" >&2
  exit 1
}

grep -q '@$(MAKE) setup' "${MAKEFILE}" || {
  echo "verify-hub must run make setup" >&2
  exit 1
}

grep -q '@$(MAKE) ci' "${MAKEFILE}" || {
  echo "verify-hub must run make ci" >&2
  exit 1
}

grep -q '@$(MAKE) test' "${MAKEFILE}" || {
  echo "verify-hub must run make test" >&2
  exit 1
}

echo "make verify-hub target checks passed."
