#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_ROOT="${WORKSPACE_ROOT:-/home/dev/Project_Me}"
MODE="${1:-check}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"

repos=(
  asdev-automation-hub
  asdev-codex-reviewer
  asdev-creator-membership-ir
  asdev-family-rosca
  asdev-nexa-vpn
  asdev-persiantoolbox
  asdev-portfolio
  asdev-standards-platform
)

fail=0

for repo in "${repos[@]}"; do
  repo_dir="${WORKSPACE_ROOT}/${repo}"
  [[ -d "${repo_dir}/.git" ]] || continue

  if [[ "${MODE}" == "fix" ]]; then
    git -C "${repo_dir}" fetch --prune >/dev/null 2>&1 || true
    git -C "${repo_dir}" checkout "${DEFAULT_BRANCH}" >/dev/null 2>&1 || true
    git -C "${repo_dir}" pull --no-rebase --autostash >/dev/null 2>&1 || true
  fi

  current_branch="$(git -C "${repo_dir}" rev-parse --abbrev-ref HEAD)"
  if [[ "${current_branch}" != "${DEFAULT_BRANCH}" ]]; then
    echo "policy_violation:${repo}:branch=${current_branch}"
    fail=1
    continue
  fi

  if ! git -C "${repo_dir}" show-ref --verify --quiet "refs/remotes/origin/${DEFAULT_BRANCH}"; then
    echo "policy_violation:${repo}:missing_origin_${DEFAULT_BRANCH}"
    fail=1
    continue
  fi

  echo "policy_ok:${repo}:${DEFAULT_BRANCH}"
done

if [[ ${fail} -ne 0 ]]; then
  exit 1
fi
