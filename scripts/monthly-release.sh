#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATE_TAG="$(date -u +%Y-%m-%d)"
BRANCH_NAME="chore/asdev-monthly-release-${DATE_TAG}"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

bump_patch() {
  local version="$1"
  local major minor patch
  IFS='.' read -r major minor patch <<< "$version"
  echo "${major}.${minor}.$((patch + 1))"
}

require_cmd git
require_cmd gh
require_cmd yq

cd "$ROOT_DIR"

git fetch origin main
if git show-ref --verify --quiet "refs/heads/${BRANCH_NAME}"; then
  git checkout "$BRANCH_NAME"
else
  git checkout -b "$BRANCH_NAME" origin/main
fi

# 1) Generate divergence snapshot
bash platform/scripts/divergence-report.sh sync/targets.yaml platform/repo-templates/templates.yaml platform/repo-templates sync/divergence-report.csv

# 2) Patch bump all template versions in manifest
count="$(yq -r '.templates | length' platform/repo-templates/templates.yaml)"
for ((i=0; i<count; i++)); do
  current="$(yq -r ".templates[$i].version" platform/repo-templates/templates.yaml)"
  next="$(bump_patch "$current")"
  yq -i ".templates[$i].version = \"$next\"" platform/repo-templates/templates.yaml
done

# 3) Governance update stub
update_file="governance/updates-${DATE_TAG}-monthly.md"
cat > "$update_file" <<STUB
# Monthly Governance Update (${DATE_TAG})

## Summary

- Monthly template version bump executed.
- Divergence snapshot regenerated.

## Action Items

- Review pilot adoption and pending divergence entries.
- Confirm next wave rollout status.
STUB

# 4) Commit and PR
if git diff --quiet; then
  echo "No changes to release."
  exit 0
fi

git add platform/repo-templates/templates.yaml sync/divergence-report.csv "$update_file"
git commit -m "chore: monthly ASDEV release ${DATE_TAG}"
git push -u origin "$BRANCH_NAME"

gh pr create \
  --repo alirezasafaeiiidev/asdev_platform \
  --head "$BRANCH_NAME" \
  --base main \
  --title "chore: monthly ASDEV release ${DATE_TAG}" \
  --body "Monthly release: template version bump, divergence snapshot, and governance update stub." \
  --label standards
