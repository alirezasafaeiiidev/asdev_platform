# Release State Source of Truth Standard

## Objective

Eliminate release-state ambiguity by enforcing one canonical status source per release train.

## Canonical Rule

- Each release train must declare one canonical status file under:
  - `docs/release/release-state-registry.md`
- Dashboards, checklists, and reports must reference this registry and never override it.

## Precedence

1. `release-state-registry.md` (authoritative)
2. execution tasklists
3. status dashboards
4. ad-hoc snapshots

## Required Fields

- release_train
- current_stage
- status (`pending|in_progress|blocked|done`)
- decision_owner
- evidence_links
- blocking_items
- updated_at_utc

## Acceptance Contract

- A release is not marked `done` unless blocking items are empty.
- If any downstream doc conflicts with registry state, CI must fail.

## CI Guardrail

- Add a consistency check script that validates dashboard/tasklist status against registry.
