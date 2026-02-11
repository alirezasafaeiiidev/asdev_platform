# Phase P Execution Plan

## P1) Delivery contract standardization (high)
- **Task ID:** P1
- **Goal:** Make PR delivery and evidence collection consistent.
- **Scope:**
  - Add repository PR template with mandatory verification table.
  - Add unified local verification target (`make verify-hub`).
- **DoD:**
  - Contributors have a single PR template and a single hub verification command.

## P2) Guardrails for verification target (high)
- **Task ID:** P2
- **Goal:** Prevent accidental removal of verification target.
- **Scope:**
  - Add test contract for `make verify-hub`.
  - Include new test in aggregate script suite.
- **DoD:**
  - Test suite fails if verification target is removed or incomplete.

## P3) Documentation sync (medium)
- **Task ID:** P3
- **Goal:** Keep operational docs aligned with automation changes.
- **Scope:**
  - Update README command list and local operations.
- **DoD:**
  - README contains `make verify-hub` and purpose.

## Execution status (2026-02-11)
- [x] P1 completed
- [x] P2 completed
- [x] P3 completed
