#!/usr/bin/env bash
set -euo pipefail

SCRIPT_FILE="scripts/weekly-governance-digest.sh"

grep -q 'DIGEST_REPO="\${DIGEST_REPO:-\${GITHUB_REPOSITORY:-alirezasafaeiiidev/asdev_platform}}"' "$SCRIPT_FILE" || {
  echo "Missing DIGEST_REPO fallback configuration" >&2
  exit 1
}

grep -q -- '--repo "\$DIGEST_REPO"' "$SCRIPT_FILE" || {
  echo "Expected digest gh commands to use DIGEST_REPO" >&2
  exit 1
}

if grep -q -- '--repo alirezasafaeiiidev/asdev_platform' "$SCRIPT_FILE"; then
  echo "Found hardcoded digest repo in script" >&2
  exit 1
fi

echo "weekly digest repo config contract checks passed."
