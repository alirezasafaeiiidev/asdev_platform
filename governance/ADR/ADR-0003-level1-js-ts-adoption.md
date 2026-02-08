# ADR-0003: Level 1 JavaScript/TypeScript Adoption Policy

- Status: Accepted
- Date: 2026-02-08
- Owners: ASDEV Platform maintainers
- Supersedes: none

## Context

Level 0 baseline is now adopted across pilot repositories. The dominant stack in pilot repos is JavaScript/TypeScript, so the first language-aware rollout should target JS/TS.

## Decision

Adopt Level 1 standards for JavaScript/TypeScript as the first language-aware track with these rules:
- Start with one pilot repository (`persian_tools`) and validate CI stability.
- Require `lint`, `test`, and `typecheck` jobs in CI for JS/TS Level 1 adoption.
- Keep rollout advisory-first through PRs; repository owners retain merge authority.
- Use package-manager-aware CI steps (for example `pnpm` where lockfile requires it).

## Consequences

Positive:
- Establishes a concrete Level 1 baseline for the most common stack.
- Reduces ambiguity for CI expectations in JS/TS repos.

Tradeoffs:
- Adds CI runtime cost.
- Requires repo-specific adaptation for package manager and scripts.
