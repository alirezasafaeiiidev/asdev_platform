# Governance Update - 2026-02-10 (Phase K)

## Summary

- Hardened runtime dependency handling for `yq` by auto-bootstrapping in operational scripts.
- Eliminated report/digest runtime fragility caused by environment `PATH` differences.
- Stabilized dashboard reliability testing against real snapshot-history interference.
- Re-ran full regression gates and confirmed green status.

## Implemented

- Added `scripts/ensure-yq.sh` integration in:
  - `platform/scripts/sync.sh`
  - `platform/scripts/divergence-report.sh`
  - `scripts/weekly-governance-digest.sh`
  - `scripts/monthly-release.sh`
  - `scripts/validate-target-template-ids.sh`
  - `scripts/generate-dashboard.sh`
- Updated `tests/test_dashboard_reliability.sh` to reset `sync/snapshots` before fixture population.

## Validation Evidence

- `make lint` passed.
- `make reports` passed.
- `make test` passed.
- `make ci` passed.

## Risk / Follow-up

- Keep weekly digest lifecycle open-state policy configurable (current stale close threshold remains 8 days).
