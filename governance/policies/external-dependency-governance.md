# External Dependency Governance Policy

- Status: Active
- Version: 1.0.0

## Purpose

Define how repositories that require runtime external services remain compliant with ASDEV core governance without violating their product constraints.

## Baseline Rule

- ASDEV defaults to local-first and minimal external runtime dependency.
- When a repository cannot be local-first by design, it is classified as `external-dependent` and must still follow ASDEV hub governance.

## Mandatory Controls For `external-dependent` Repositories

1. Keep ASDEV core controls enabled:
   - `AGENT.md` + human approval gates
   - CI quality gates
   - security checklist alignment
   - documentation/change evidence in PRs
2. Maintain an external dependency register in repo docs:
   - service name
   - purpose
   - required data exchanged
   - failure mode and fallback behavior
3. Define runtime failure posture:
   - graceful degradation behavior
   - retry/backoff boundaries
   - operator runbook for outage mode
4. Restrict scope of external access:
   - explicit allowlist by domain/provider
   - no unmanaged telemetry/data exfiltration
5. Classify changes to external integrations as gated:
   - provider switch
   - data-contract changes
   - new egress path
   - secret model changes

## Exception Registry

Approved runtime exceptions are tracked in sync targets and reviewed in governance updates.

Current approved exception:

- Repository: `alirezasafaeiiidev/asdev-nexa-vpn`
- Profile: `external-dependent`
- Rationale: product runtime requires external VPN/network providers.
- Governance requirement: must follow ASDEV core standards from `asdev-standards-platform`.

## Review Cadence

- Review each `external-dependent` exception at least once per quarter.
- Confirm controls are still sufficient and rationale still valid.
- Remove exception when local-first parity becomes feasible.
