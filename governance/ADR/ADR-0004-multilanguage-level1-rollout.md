# ADR-0004: Multi-language Level 1 Rollout Strategy

- Status: Accepted
- Date: 2026-02-08
- Owners: ASDEV Platform maintainers

## Context

After successful Level 1 adoption on JS/TS pilot repositories, ASDEV needs a predictable multi-language rollout strategy that minimizes rollout risk and keeps advisory-first governance.

## Decision

Adopt the Level 1 rollout order:
- Wave 1: JavaScript/TypeScript
- Wave 2: Python
- Wave 3: Go

Entrance criteria per language:
- Baseline standards document exists under `standards/coding/`.
- CI baseline template exists under `platform/ci-templates/`.
- Sync target mapping exists and is limited to pilot-ready repositories.
- Required script contract is documented (`lint`, `test`, optional language-specific checks).

Exit criteria per wave:
- At least one pilot repository merged Level 1 PR.
- Divergence report shows no `missing` for wave templates in pilot targets.
- Governance update note published with rollout status.

Rollback conditions:
- CI instability causes repeated PR failures.
- Required script contract is not available in pilot repositories.
- Maintainer feedback indicates rollout friction beyond advisory tolerance.

## Consequences

Positive:
- Establishes deterministic sequencing and measurable rollout quality gates.
- Reduces ad-hoc decisions for adding new language standards.

Tradeoffs:
- Later waves wait for earlier wave stabilization.
- Adds governance overhead per rollout wave.
