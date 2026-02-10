# Phase K Execution Plan

## K1) Auto-bootstrap `yq` in runtime scripts (high)
- **Task ID:** K1
- **Goal:** Remove environment-dependent failures where `yq` exists but is not in `PATH`.
- **DoD:**
  - Scripts that require `yq` call `scripts/ensure-yq.sh`.
  - Runtime `PATH` is augmented automatically before `yq` calls.

## K2) Re-validate reports and digest pipelines end-to-end (high)
- **Task ID:** K2
- **Goal:** Confirm report generation and weekly digest creation/update run without manual environment prep.
- **DoD:**
  - `make reports` passes.
  - `bash scripts/weekly-governance-digest.sh` passes.

## K3) Stabilize dashboard reliability test isolation (high)
- **Task ID:** K3
- **Goal:** Prevent fixture collision with real snapshot files.
- **DoD:**
  - `tests/test_dashboard_reliability.sh` resets `sync/snapshots` before fixture creation.
  - `make test` passes deterministically.

## K4) Final regression gate (high)
- **Task ID:** K4
- **Goal:** Ensure no regressions after K1-K3.
- **DoD:**
  - `make ci` passes.

## Status
- [x] K1 done
  - Added `ensure-yq` bootstrap in:
    - `platform/scripts/sync.sh`
    - `platform/scripts/divergence-report.sh`
    - `scripts/weekly-governance-digest.sh`
    - `scripts/monthly-release.sh`
    - `scripts/validate-target-template-ids.sh`
    - `scripts/generate-dashboard.sh`
- [x] K2 done
  - `make reports` passed.
  - Weekly digest script executed successfully and updated current issue.
- [x] K3 done
  - Isolated snapshots in `tests/test_dashboard_reliability.sh`.
- [x] K4 done
  - `make ci` passed.
