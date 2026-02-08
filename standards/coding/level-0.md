# Coding Standards Level 0 (Language-Agnostic)

- Status: Active
- Version: 1.1.0
- Source ADRs: ADR-0001, ADR-0002

## Goals

Provide a low-friction baseline that can be applied to all repositories regardless of tech stack.

## Requirements

### Must

- Repository contains a minimum `README.md` structure.
- Repository has a pull request template.
- Repository has baseline issue templates for bug and feature request.
- Repository has a minimum `CONTRIBUTING.md`.
- Repository has a lightweight CI sanity workflow (lint/test placeholders).

### Should

- Commit and branch naming follow documented conventions.
- CI workflow should be extended with stack-specific jobs.
- Sync should be non-destructive for existing documentation files by default.

### Optional

- `.editorconfig`
- `CODEOWNERS`

## Naming Conventions

- Branch: `type/short-description` (example: `chore/asdev-sync-20260208`)
- Commit: Conventional Commits (example: `chore: sync ASDEV Level 0 templates`)
- PR title: concise and traceable to standard/adrs

## Adoption Safety Defaults (v1.1.0)

To reduce adoption friction:
- Sync keeps `README.md` and `CONTRIBUTING.md` unchanged when those files already exist.
- Forced overwrite is opt-in (`FORCE_OVERWRITE_DOCS=true`).
- `CODEOWNERS` template uses a neutral placeholder that must be customized by consumer owners.
