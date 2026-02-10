#!/usr/bin/env bash
set -euo pipefail

SCRIPT_FILE="scripts/monthly-release.sh"

grep -q 'BASE_BRANCH="\${BASE_BRANCH:-main}"' "$SCRIPT_FILE" || {
  echo "Missing BASE_BRANCH configuration" >&2
  exit 1
}

grep -q 'RELEASE_REPO="\${RELEASE_REPO:-\${GITHUB_REPOSITORY:-alirezasafaeiiidev/asdev_platform}}"' "$SCRIPT_FILE" || {
  echo "Missing RELEASE_REPO fallback configuration" >&2
  exit 1
}

grep -q -- '--repo "\$RELEASE_REPO"' "$SCRIPT_FILE" || {
  echo "Expected monthly release PR command to use RELEASE_REPO" >&2
  exit 1
}

if grep -q -- '--repo alirezasafaeiiidev/asdev_platform' "$SCRIPT_FILE"; then
  echo "Found hardcoded monthly release repo in script" >&2
  exit 1
fi

echo "monthly release repo config contract checks passed."
