# JavaScript/TypeScript CI Baseline (Level 1)

- Status: Draft
- Version: 0.1.0
- Source ADRs: ADR-0001, ADR-0002
- Depends on: standards/coding/level-1-javascript-typescript.md

## Workflow Triggers

- `pull_request`
- `push` to default branch

## Required Jobs

- `lint`: run `npm run lint`
- `test`: run `npm run test`
- `typecheck` (conditional): run `npm run typecheck` if script exists
