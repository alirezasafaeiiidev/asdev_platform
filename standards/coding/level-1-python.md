# Coding Standards Level 1 (Python)

- Status: Draft
- Version: 0.1.0
- Source ADRs: ADR-0001, ADR-0002, ADR-0004
- Depends on: standards/coding/level-0.md

## Scope

Applies to repositories with Python as primary language.

## Must

- Python version pinned (for example `.python-version` or toolchain config).
- `ruff` configured for linting/format checks.
- `pytest` configured for tests.
- CI runs lint + test on PR and default branch pushes.

## Should

- Type checks via `mypy` or equivalent.
- Test coverage reporting enabled in CI.
- Dependency security checks (for example `pip-audit`) in scheduled jobs.

## Optional

- Performance regression test suite.
- Contract/integration test layer.
