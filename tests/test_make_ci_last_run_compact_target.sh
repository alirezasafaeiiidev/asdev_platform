#!/usr/bin/env bash
set -euo pipefail

output="$(make -n ci-last-run-compact)"

required_patterns=(
  'if \[\[ "\$\{GH_FORCE_MISSING:-false\}" == "true" \]\] \|\| ! command -v gh >/dev/null 2>&1; then'
  'echo "n/a'
  'gh run list --repo "\$repo" --limit 1 --json databaseId,conclusion'
)

for pattern in "${required_patterns[@]}"; do
  if ! printf '%s\n' "$output" | grep -Eq "$pattern"; then
    echo "ci-last-run-compact target missing expected command pattern: $pattern" >&2
    exit 1
  fi
done

echo "make ci-last-run-compact target checks passed."
