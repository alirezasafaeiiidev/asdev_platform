# Phase B Next Execution Tasks

## T1. Roll out Level 0 v1.1.0 to pilot repos
- [ ] Run `DRY_RUN=true` sync against `sync/targets.yaml`.
- [ ] Run live sync and open update PRs for all pilot repos.
- [ ] Verify `README.md` and `CONTRIBUTING.md` are preserved where already present.

## T2. Adopt JS/TS Level 1 on one pilot repo
- [ ] Select first pilot repo (recommended: `persian_tools`).
- [ ] Add `platform/ci-templates/.github/workflows/js-ts-level1.yml` as repo CI workflow.
- [ ] Ensure `npm run lint`, `npm run test` and optional `npm run typecheck` exist.

## T3. Measure rollout
- [ ] Generate `sync/divergence-report.csv` after v1.1.0 rollout.
- [ ] Record status counts: `aligned`, `diverged`, `missing`, `opted_out`.
- [ ] Publish summary in a short governance update note.

## T4. Governance hardening
- [ ] Add ADR-0003 for Level 1 JS/TS adoption policy.
- [ ] Define upgrade cadence for template versions (monthly or per-change).

## T5. Automation hardening
- [ ] Add shell tests for path resolution and preserve-doc behavior in `sync.sh`.
- [ ] Add CI in `asdev_platform` to run `make lint` and `make test` on PRs.
