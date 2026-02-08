# Go CI Baseline (Level 1)

- Status: Draft
- Version: 0.1.0
- Source ADRs: ADR-0001, ADR-0002, ADR-0004
- Depends on: standards/coding/level-1-go.md

## Workflow Triggers

- `pull_request`
- `push` to default branch

## Required Jobs

- `lint`: run `golangci-lint run`
- `test`: run `go test ./...`

## Recommended Jobs

- `test-race`: run `go test -race ./...`
- `vulncheck`: run `govulncheck ./...`
