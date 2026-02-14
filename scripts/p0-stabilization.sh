#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TODAY="$(date +%F)"
REPORT_FILE="${REPO_ROOT}/docs/reports/P0_STABILIZATION_${TODAY}.md"
WORKSPACE_ROOT="${WORKSPACE_ROOT:-/home/dev/Project_Me}"
SKIP_BASELINE="${SKIP_BASELINE:-false}"
BASELINE_REPOS="${BASELINE_REPOS:-asdev-standards-platform asdev-automation-hub asdev-creator-membership-ir asdev-family-rosca asdev-nexa-vpn asdev-persiantoolbox asdev-portfolio asdev-codex-reviewer}"

freeze_status="PASS"
sync_status="PASS"
auth_status="PASS"
baseline_status="PASS"
freeze_detail=""
sync_detail=""
auth_detail=""
baseline_detail=""

if out="$(bash "${SCRIPT_DIR}/automation-freeze-guard.sh" 2>&1)"; then
  freeze_detail="${out}"
else
  freeze_status="FAIL"
  freeze_detail="${out}"
fi

if out="$(WORKSPACE_ROOT="${WORKSPACE_ROOT}" bash "${SCRIPT_DIR}/enforce-main-sync-policy.sh" check 2>&1)"; then
  sync_detail="${out}"
else
  sync_status="FAIL"
  sync_detail="${out}"
fi

if out="$(bash "${SCRIPT_DIR}/github-app-auth-guard.sh" 2>&1)"; then
  auth_detail="${out}"
else
  auth_status="FAIL"
  auth_detail="${out}"
fi

if [[ "${SKIP_BASELINE}" != "true" ]]; then
for repo in ${BASELINE_REPOS}; do
  repo_dir="${WORKSPACE_ROOT}/${repo}"
  [[ -d "${repo_dir}/.git" ]] || continue

  case "${repo}" in
    asdev-standards-platform)
      cmd='make -s lint && make -s typecheck && make -s test && make -s build'
      ;;
    asdev-automation-hub)
      cmd='pnpm -s lint && pnpm -s typecheck && pnpm -s test && pnpm -s build'
      ;;
    asdev-creator-membership-ir)
      cmd='pnpm -s lint && pnpm -s typecheck && pnpm -s test'
      ;;
    asdev-family-rosca)
      cmd='bun run lint && bun run test && bun run build'
      ;;
    asdev-nexa-vpn)
      cmd='bun run lint && bun run test && bun run build'
      ;;
    asdev-persiantoolbox)
      cmd='pnpm -s lint && pnpm -s typecheck && pnpm -s test -- --run && pnpm -s build'
      ;;
    asdev-portfolio)
      cmd='bun run lint && bun run type-check && bun run test && bun run build'
      ;;
    asdev-codex-reviewer)
      cmd='test -f README.md'
      ;;
  esac

  if ! timeout 1800 bash -lc "cd '${repo_dir}' && ${cmd}" >/tmp/p0_${repo}.log 2>&1; then
    baseline_status="FAIL"
    baseline_detail+="${repo}:FAILED (see /tmp/p0_${repo}.log)\n"
  else
    baseline_detail+="${repo}:PASS\n"
  fi
done
else
  baseline_detail="skipped_by_config\n"
fi

freeze_detail_cell="$(echo "${freeze_detail}" | tr '\n' ';' | sed 's/|/\\|/g')"
sync_detail_cell="$(echo "${sync_detail}" | tr '\n' ';' | sed 's/|/\\|/g')"
auth_detail_cell="$(echo "${auth_detail}" | tr '\n' ';' | sed 's/|/\\|/g')"
baseline_detail_cell="$(echo -e "${baseline_detail}" | tr '\n' ';' | sed 's/|/\\|/g')"

{
  echo "# P0 Stabilization Report (${TODAY})"
  echo
  echo "- Generated: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
  echo
  echo "| Check | Status | Detail |"
  echo "|---|---|---|"
  echo "| Freeze Guard | ${freeze_status} | ${freeze_detail_cell} |"
  echo "| Main Branch Sync Policy | ${sync_status} | ${sync_detail_cell} |"
  echo "| GitHub App Auth Guard | ${auth_status} | ${auth_detail_cell} |"
  echo "| Baseline Health (lint/typecheck/test/build) | ${baseline_status} | ${baseline_detail_cell} |"
} > "${REPORT_FILE}"

echo "p0_report:${REPORT_FILE}"
if [[ "${freeze_status}" != "PASS" || "${sync_status}" != "PASS" || "${auth_status}" != "PASS" || "${baseline_status}" != "PASS" ]]; then
  exit 1
fi
