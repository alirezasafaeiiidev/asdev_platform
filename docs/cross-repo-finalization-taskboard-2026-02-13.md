# Cross-Repo Finalization Taskboard (2026-02-13)

Scope: `asdev-automation-hub`, `asdev-portfolio`, `asdev-persiantoolbox`, `asdev-standards-platform`

## Current Snapshot

- All four repositories have merged the rollout PRs to `main`.
- `main` branch protection is enabled in all four repositories.
- Protection baseline after merge remains strict: `required_approving_review_count=1` and `require_code_owner_reviews=true`.
- Local repositories are synced to latest `origin/main`.

## Repo Matrix

| Repository | PR | CI State | Merge Gate | Auto-Merge |
| --- | --- | --- | --- | --- |
| `asdev-automation-hub` | #2 (merged) | Pass | Completed | N/A |
| `asdev-portfolio` | #14 (merged) | Pass | Completed | N/A |
| `asdev-persiantoolbox` | #15 (merged) | Pass | Completed | N/A |
| `asdev-standards-platform` | #123 (merged) | Pass | Completed | N/A |

## Phase-Based Execution (No Calendar Dependency)

### Phase 1: Merge Gate Completion

- [x] Get one non-author approving review on each PR or execute controlled merge fallback.
- [x] Ensure review/CODEOWNERS merge gate is satisfied and restored after merge.
- [x] Ensure all PR conversations are resolved or non-blocking before merge.

### Phase 2: Automatic Merge Confirmation

- [x] Confirm each PR is merged to `main`.
- [x] Confirm remote branch is deleted after merge.
- [x] Confirm required checks remain green on merge commit.

### Phase 3: Post-Merge Stabilization

- [x] Pull latest `main` locally in all four repositories.
- [ ] Tag release candidate or patch version where applicable.
- [x] Run smoke verification on merged `main`.
- [x] Confirm branch protection contexts still match active workflow names.

### Phase 4: Hardening Follow-Up

- [ ] Add reviewer rotation policy for CODEOWNERS paths.
- [ ] Add merge runbook references to each repository README.
- [ ] Archive this taskboard after all checkboxes are complete.

## Parallel Execution Profile

Use these in parallel sessions to maximize local throughput:

```bash
# Session A: watch PR checks
watch -n 20 'gh pr checks 2 --repo alirezasafaeiiidev/asdev-automation-hub && echo && gh pr checks 14 --repo alirezasafaeiiidev/asdev-portfolio'

# Session B: watch remaining repos
watch -n 20 'gh pr checks 15 --repo alirezasafaeiiidev/asdev-persiantoolbox && echo && gh pr checks 123 --repo alirezasafaeiiidev/asdev-standards-platform'

# Session C: watch merge state
watch -n 20 'gh pr view 2 --repo alirezasafaeiiidev/asdev-automation-hub --json mergeStateStatus,reviewDecision && echo && gh pr view 14 --repo alirezasafaeiiidev/asdev-portfolio --json mergeStateStatus,reviewDecision && echo && gh pr view 15 --repo alirezasafaeiiidev/asdev-persiantoolbox --json mergeStateStatus,reviewDecision && echo && gh pr view 123 --repo alirezasafaeiiidev/asdev-standards-platform --json mergeStateStatus,reviewDecision'
```

## Definition of Done

- [x] All 4 PRs merged to `main`.
- [x] No required check is failing on `main` after merge.
- [x] Protection policies are still active and aligned with workflows.
- [x] Remaining follow-up issue list is empty or moved to backlog.
