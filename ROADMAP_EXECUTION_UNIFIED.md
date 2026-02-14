# Unified Execution Roadmap (All ASDEV Projects)

## Scope
این نقشه راه تنها سند اجرایی مرجع برای کل پروژه‌ها است:
- asdev-automation-hub
- asdev-codex-reviewer
- asdev-creator-membership-ir
- asdev-family-rosca
- asdev-nexa-vpn
- asdev-persiantoolbox
- asdev-portfolio
- asdev-standards-platform

## Priority Order
1. asdev-standards-platform
2. asdev-portfolio
3. asdev-persiantoolbox
4. asdev-automation-hub
5. asdev-creator-membership-ir
6. asdev-family-rosca
7. asdev-nexa-vpn
8. asdev-codex-reviewer

## Phase 0 - Stabilization (Critical)
### Tasks
- [ ] Freeze runtime automation during release windows.
- [ ] Enforce single-branch sync policy on `main` for all repos.
- [ ] Remove legacy tokens/secrets and validate GitHub App auth only.
- [ ] Baseline health checks: lint, typecheck, test, build.

## Phase 1 - Delivery Core (High)
### Tasks
- [ ] asdev-portfolio: finalize lead funnel + service pages + API stability.
- [ ] asdev-persiantoolbox: stabilize release gates and licensing contracts.
- [ ] asdev-automation-hub: harden orchestration workflows and admin controls.
- [ ] asdev-standards-platform: keep standards sync and governance automation green.

## Phase 2 - Product Reliability (High)
### Tasks
- [ ] Add deterministic CI gates for each repo (quality/security/contracts).
- [ ] Standardize release checklist and rollback drill across projects.
- [ ] Add dependency/security audit cadence with fail-on-critical policy.
- [ ] Track production readiness score per repo weekly.

## Phase 3 - Growth Execution (Medium)
### Tasks
- [ ] asdev-creator-membership-ir: monetization flow and conversion metrics.
- [ ] asdev-family-rosca: onboarding and trust/SEO hardening.
- [ ] asdev-nexa-vpn: acquisition pages + technical SEO + deployment reliability.
- [ ] Cross-repo: shared analytics KPIs (traffic, leads, conversion, retention).

## Phase 4 - Operational Excellence (Medium)
### Tasks
- [ ] Full incident runbook per repo (alerts, triage, owner, SLA).
- [ ] Weekly executive dashboard from one data pipeline.
- [ ] Remove redundant scripts/config drift between repos.
- [ ] Enforce ownership map and bus-factor reduction for critical paths.

## Phase 5 - Scale and Automation (Ongoing)
### Tasks
- [ ] Automatic dependency update and compatibility verification.
- [ ] Scheduled autonomous maintenance PRs with strict merge policies.
- [ ] Cost/performance optimization per service and environment.
- [ ] Quarterly roadmap re-prioritization based on KPI outcomes.

## Definition of Done (Per Task)
- [ ] Code merged to `main`
- [ ] CI green
- [ ] Security checks green
- [ ] Operational owner assigned
- [ ] KPI impact recorded
