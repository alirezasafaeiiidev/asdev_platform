# Coding Standards Level 1 (JavaScript/TypeScript)

- Status: Draft
- Version: 0.1.0
- Source ADRs: ADR-0001, ADR-0002
- Depends on: standards/coding/level-0.md

## Scope

Applies to repositories with JS/TS as primary language.

## Must

- `node` runtime version pinned (`.nvmrc` or `engines` in `package.json`).
- `npm run lint` command exists.
- `npm run test` command exists.
- PR CI runs lint + test.

## Should

- TypeScript projects run `tsc --noEmit` in CI.
- Use shared ESLint + Prettier configuration.
- Enforce import/order and unused variable checks.

## Optional

- Bundle size budgets.
- Coverage thresholds.
- Playwright/Cypress smoke checks.

## Minimum CI Contract

- Install dependencies using lockfile-respecting command.
- Execute lint.
- Execute tests.
- Execute typecheck if TypeScript is present.
