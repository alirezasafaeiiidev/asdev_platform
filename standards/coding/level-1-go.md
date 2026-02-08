# Coding Standards Level 1 (Go)

- Status: Draft
- Version: 0.1.0
- Source ADRs: ADR-0001, ADR-0002, ADR-0004
- Depends on: standards/coding/level-0.md

## Scope

Applies to repositories with Go as primary language.

## Must

- Go version pinned in `go.mod` and CI runtime.
- `golangci-lint` configured.
- `go test ./...` runs in CI.

## Should

- Race detector checks in CI (`go test -race ./...`).
- Vulnerability checks (`govulncheck`) in scheduled jobs.

## Optional

- Benchmarks for critical packages.
- Integration test environment matrix.
