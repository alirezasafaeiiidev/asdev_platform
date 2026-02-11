# Phase O Execution Plan

## O1) Repository hygiene enforcement (high)
- **Task ID:** O1
- **Goal:** Prevent dead artifacts and empty directories from regressing into the repo.
- **Scope:**
  - Add deterministic hygiene script (`check`/`fix`).
  - Wire hygiene checks into `make lint` and dedicated `make hygiene` target.
  - Add ignore patterns for generated local cache files.
- **DoD:**
  - Hygiene guard fails on artifacts and passes on clean repo.
  - Local command `make hygiene` is documented and stable.

## O2) CI gate hardening (high)
- **Task ID:** O2
- **Goal:** Enforce hygiene gate in Actions pipeline before policy/test stages.
- **Scope:**
  - Add explicit `Repository Hygiene` step in `.github/workflows/ci.yml`.
- **DoD:**
  - Workflow contains dedicated hygiene step and remains contract-compliant.

## O3) Regression tests for hygiene contract (high)
- **Task ID:** O3
- **Goal:** Lock behavior with deterministic tests.
- **Scope:**
  - Add script-level test for hygiene script behavior.
  - Add make-target test for `make hygiene`.
  - Include both in `tests/test_scripts.sh`.
- **DoD:**
  - `make test` passes with hygiene tests included.

## O4) Documentation and closure evidence (medium)
- **Task ID:** O4
- **Goal:** Keep rollout traceable for future contributors.
- **Scope:**
  - Add `docs/repo-hygiene.md`.
  - Update README with policy link and operational command.
  - Record governance update with verification evidence.
- **DoD:**
  - Docs reference hygiene policy and command path.
  - Verification commands recorded with outcomes.

## Execution status (2026-02-11)
- [x] O1 completed
- [x] O2 completed
- [x] O3 completed
- [x] O4 completed
