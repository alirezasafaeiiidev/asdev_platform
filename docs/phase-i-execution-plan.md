# Phase I Execution Plan

## I1) Add compact CI last-run target (high)
- **Task ID:** I1
- **Goal:** Add `make ci-last-run-compact` to print only `run id` and `conclusion` in one line.
- **DoD:**
  - Make target exists and works with `gh`.
  - Fallback path is deterministic when `gh` is unavailable.

## I2) Enforce strict JSON fallback contract (high)
- **Task ID:** I2
- **Goal:** Keep `make ci-last-run-json` fallback exactly `{}`.
- **DoD:**
  - Contract test checks exact output equality on fallback path.

## I3) Validate with full lint/test cycle (high)
- **Task ID:** I3
- **Goal:** Ensure no regressions.
- **DoD:**
  - `make lint` passes.
  - `make test` passes.

## I4) Add README automation example for ci-last-run-json (medium)
- **Task ID:** I4
- **Goal:** Document one shell example with `jq` field extraction.
- **DoD:**
  - README includes a short script snippet using `jq` over `make ci-last-run-json`.

## Status
- [x] I1 done
  - Added `ci-last-run-compact` target in `Makefile`.
  - Added deterministic fallback output: `n/a<TAB>n/a`.
- [x] I2 done
  - Hardened fallback contract test in `tests/test_make_ci_last_run_fallback.sh`.
  - Ensured deterministic invocation with `make --no-print-directory`.
- [x] I3 done
  - `make lint` passed.
  - `make test` and `make ci` passed.
- [x] I4 done
  - Added shell automation snippet with `jq` extraction in `README.md`.
