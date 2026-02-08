# Phase B Next Execution Tasks

## T1. Roll out Level 0 v1.1.0 to pilot repos
- [x] Run `DRY_RUN=true` sync against `sync/targets.yaml`.
- [x] Run live sync and open update PRs for all pilot repos.
- [x] Verify `README.md` and `CONTRIBUTING.md` are preserved where already present.

## T2. Adopt JS/TS Level 1 on one pilot repo
- [x] Select first pilot repo (recommended: `persian_tools`).
- [x] Add `platform/ci-templates/.github/workflows/js-ts-level1.yml` as repo CI workflow.
- [x] Ensure `npm run lint`, `npm run test` and optional `npm run typecheck` exist.

## T3. Measure rollout
- [x] Generate `sync/divergence-report.csv` after v1.1.0 rollout.
- [x] Record status counts: `aligned`, `diverged`, `missing`, `opted_out`.
- [x] Publish summary in a short governance update note.

## T4. Governance hardening
- [x] Add ADR-0003 for Level 1 JS/TS adoption policy.
- [x] Define upgrade cadence for template versions (monthly or per-change).

## T5. Automation hardening
- [x] Add shell tests for path resolution and preserve-doc behavior in `sync.sh`.
- [x] Add CI in `asdev_platform` to run `make lint` and `make test` on PRs.

## Next Execution Tasks (Phase C)
- [ ] Expand Level 1 JS/TS rollout to `my_portfolio`.
- [ ] Add `sync/targets.level1.yaml` with per-repo language-aware template selection.
- [ ] Extend divergence report with `mode` and `source_ref` columns.
- [ ] Add monthly release task to bump template versions and publish governance update.
- [ ] Introduce ADR-0004 for multi-language Level 1 rollout strategy (Python/Go sequencing).
