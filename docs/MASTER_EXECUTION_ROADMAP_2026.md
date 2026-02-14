# Master Execution Roadmap 2026

## 1) Metadata

- Document owner: ASDEV Platform Governance
- Last update: 2026-02-14
- Scope: Cross-repository execution for:
  - `asdev-standards-platform`
  - `asdev-portfolio`
  - `asdev-persiantoolbox`
- Source of truth: This file is the primary execution reference for phased delivery.

## 2) Strategic Objective

Build a production-grade, brand-aligned, and SEO-ready execution system across core repositories with:

- Phased delivery and auditable task ownership
- Security and operational hardening before expansion
- Consulting-funnel conversion optimization in portfolio
- Cross-repo standards enforcement from `asdev-standards-platform`

## 3) Locked Decisions

- Positioning (canonical):
  - `Alireza Safaei — Production-Grade Web Systems Consultant | Architecture & CI/CD Hardening | Helping SaaS Founders Reach Real Production Stability`
- Core offer:
  - `Infrastructure Localization & Operational Resilience Program (4-Week Program)`
- Primary ICP:
  - `Government contractors`
- Pricing visibility:
  - `Public range: 60–120M IRR`
- Lead intake:
  - `CRM form`
- Landing strategy:
  - `Portfolio main page + dedicated service subpage`
- SEO strategy:
  - `Persian-first (FA canonical, EN supporting)`
- Cache strategy:
  - `SWR for marketing routes`, `no-store` for sensitive routes

## 4) Execution Principles

- No phase closes without evidence.
- No quality-gate bypass for merge to protected branches.
- No release-state ambiguity between dashboards and tasklists.
- No hidden production risk accepted as "postpone later" for critical items.

## 5) Phase Matrix

| Phase | Name | Primary Goal | Exit Gate |
|---|---|---|---|
| 0 | Critical Risk Closure | Remove immediate security/release truth risks | All critical risks closed with evidence |
| 1 | Portfolio Consulting Funnel | Convert portfolio into revenue engine | Lead flow works end-to-end |
| 2 | SEO Production Hardening | Fix technical SEO blockers and authority graph | SEO contracts pass in CI |
| 3 | Release Governance & Ops Maturity | Enforce production-grade release/ops discipline | Release source-of-truth and runbooks validated |
| 4 | Standards Externalization & Adoption | Codify and distribute standards cross-repo | Adoption matrix and CI guardrails green |

---

## 6) Phase 0 — Critical Risk Closure

### 6.1 Goal
Eliminate immediate operational and release-governance risks before further expansion.

### 6.2 Tasks

- `P0-T1` Systemd privilege hardening in portfolio
  - Repo: `asdev-portfolio`
  - Scope:
    - `ops/systemd/my-portfolio-production.service`
    - `ops/systemd/my-portfolio-staging.service`
  - Action:
    - Replace `User=root` with least-privileged runtime user.
    - Align `PM2_HOME` with non-root service user.

- `P0-T2` Sensitive-route cache contract hardening
  - Repo: `asdev-portfolio`
  - Scope:
    - `src/proxy.ts`
    - `next.config.ts`
  - Action:
    - Enforce `no-store` for `/api/*`, `/admin/*`, account/auth-sensitive routes.
    - Keep SWR for safe marketing pages.

- `P0-T3` Release truth alignment for persiantoolbox
  - Repo: `asdev-persiantoolbox`
  - Scope:
    - `docs/release/v3-readiness-dashboard.md`
    - `docs/release/reports/v3-publish-tasklist-2026-02-12T19-39-24Z.md`
  - Action:
    - Resolve status conflicts.
    - Keep one canonical release status.

- `P0-T4` Release state policy standardization
  - Repo: `asdev-standards-platform`
  - Scope:
    - New standard under `standards/ops/`
  - Action:
    - Define release status sources, precedence, and evidence requirements.

### 6.3 Deliverables

- Systemd hardening PR
- Cache policy contract PR
- Release truth alignment PR
- Release source-of-truth policy doc

### 6.4 Acceptance Criteria

- No root-owned runtime service for portfolio.
- Sensitive endpoints are non-cacheable in production.
- No contradictory release status across official docs.
- Policy published and referenced by all core repos.

### 6.5 Mandatory End-of-Phase Documentation

- `docs/reports/PHASE_0_CLOSURE_REPORT.md` in each impacted repo including:
  - merged PR links
  - before/after snapshots
  - command evidence
  - residual risk list

---

## 7) Phase 1 — Portfolio Consulting Funnel

### 7.1 Goal
Turn `asdev-portfolio` into a high-intent consulting conversion engine.

### 7.2 Tasks

- `P1-T1` Information architecture migration (funnel-first)
  - Sections:
    - Positioning
    - Service offer
    - Case/proof
    - Trust signals
    - Lead CTA

- `P1-T2` Service subpage for 4-week program
  - Include:
    - Week-by-week structure
    - Deliverables
    - Scope in/out
    - Pricing range

- `P1-T3` CRM lead form implementation
  - Required fields:
    - organization type
    - technical team size
    - current infra stack
    - primary risk
    - timeline
    - budget band
    - preferred contact channel

- `P1-T4` Positioning consistency
  - Canonical EN positioning + FA supporting equivalent
  - Align hero, metadata, footer attribution, and service page copy

### 7.3 Deliverables

- Funnel IA implementation PR
- Service subpage PR
- CRM intake PR
- Positioning copybook doc

### 7.4 Acceptance Criteria

- User can complete lead flow from landing to CRM capture.
- CTA path is stable on desktop/mobile.
- Messaging is consistent across main conversion surfaces.

### 7.5 Mandatory End-of-Phase Documentation

- `docs/reports/PHASE_1_FUNNEL_REPORT.md`
  - conversion flow map
  - lead schema
  - test evidence
  - baseline KPIs

---

## 8) Phase 2 — SEO Production Hardening

### 8.1 Goal
Eliminate technical SEO blockers and establish authority-grade entity structure.

### 8.2 Tasks

- `P2-T1` Canonical base URL hardening
  - Repo: `asdev-portfolio`
  - Scope:
    - `src/lib/site-config.ts`
  - Action:
    - Remove placeholder fallback for production.
    - Use strict environment-driven canonical source.

- `P2-T2` Sitemap cleanup
  - Repo: `asdev-portfolio`
  - Scope:
    - `src/app/sitemap.ts`
  - Action:
    - Remove fragment/hash URLs.
    - Keep only indexable URLs.

- `P2-T3` Entity schema completion
  - Repo: `asdev-portfolio`
  - Scope:
    - `src/lib/seo.ts`
    - `src/app/layout.tsx`
  - Action:
    - Ensure `Person`, `Organization`, `Service`, `WebSite` schemas are complete and consistent.

- `P2-T4` Internal linking graph
  - Cross-repo:
    - portfolio <-> standards docs <-> persiantoolbox proof pages
  - Action:
    - Add intent-aware links for authority and conversion support.

- `P2-T5` SEO contract tests in CI
  - Add gates for canonical, sitemap validity, and required schema presence.

### 8.3 Deliverables

- SEO hardening PR set
- SEO CI contract tests
- Internal linking graph document

### 8.4 Acceptance Criteria

- No sitemap fragment URL.
- Canonical host is valid in production.
- Required schema blocks pass contract checks.
- SEO gates run in CI and block regressions.

### 8.5 Mandatory End-of-Phase Documentation

- `docs/reports/PHASE_2_SEO_REPORT.md`
  - validator outputs
  - CI run links
  - indexability notes
  - remaining opportunities

---

## 9) Phase 3 — Release Governance & Ops Maturity

### 9.1 Goal
Reach reliable, auditable production operations with clear go/no-go governance.

### 9.2 Tasks

- `P3-T1` Release State Registry
  - Define canonical status artifact and precedence.

- `P3-T2` Runbook maturity
  - Align incident, rollback, and DR runbooks with real execution scripts.

- `P3-T3` Pre/Post deploy hardening
  - Enforce immutable acceptance checklist before production rollout.

- `P3-T4` SLO and alerting validation
  - Ensure alert routes and SLO evidence are operationally real.

### 9.3 Deliverables

- Governance registry doc
- Runbook pack alignment PR
- Deploy acceptance checklist contract
- SLO/alert evidence report

### 9.4 Acceptance Criteria

- Go/no-go decision can be derived from one canonical state source.
- Rollback and incident playbooks are validated against reality.
- Production deploy decision is evidence-based, not narrative-based.

### 9.5 Mandatory End-of-Phase Documentation

- `docs/reports/PHASE_3_OPS_REPORT.md`
  - release decision evidence
  - incident/rollback drill references
  - SLO and alerting status

---

## 10) Phase 4 — Standards Externalization & Adoption

### 10.1 Goal
Convert successful execution patterns into enforceable shared standards.

### 10.2 Tasks

- `P4-T1` Add official standards in platform
  - Branding standard
  - Technical SEO standard
  - Release-state policy
  - Consulting funnel UX standard

- `P4-T2` Build reusable templates
  - footer attribution
  - about-brand page
  - canonical/sitemap/schema contracts

- `P4-T3` Cross-repo adoption
  - Apply standards via sync workflow and targeted PRs.

- `P4-T4` Cross-repo quality guardrails
  - Enable and enforce CI checks for standardized contracts.

### 10.3 Deliverables

- Standards documentation pack
- Template pack
- Adoption PRs
- Adoption matrix report

### 10.4 Acceptance Criteria

- Core repositories adopt the standards with green CI.
- Regression is blocked by standardized gates.

### 10.5 Mandatory End-of-Phase Documentation

- `docs/reports/PHASE_4_STANDARDIZATION_REPORT.md`
  - adoption matrix
  - PR/evidence links
  - policy compliance summary

---

## 11) Global Quality Gates (Non-Negotiable)

Every phase requires:

- `lint`, `typecheck`, `test`, `build` green
- Security checks green for changed surfaces
- Relevant contract tests green (SEO/release-state/cache/security headers)
- Documentation closure file completed and linked

No phase may be marked complete without passing all applicable gates.

## 12) Definition of Done (Per Phase)

A phase is `Done` only when all are true:

- All phase tasks are closed with merged PRs.
- Acceptance criteria are verifiably met.
- End-of-phase documentation exists and is evidence-backed.
- Residual risk list is explicit and assigned.

## 13) Risk Register (Operational)

| Risk ID | Risk | Probability | Impact | Owner | Mitigation |
|---|---|---:|---:|---|---|
| R-01 | Root runtime services | Medium | High | Portfolio Ops | Non-root systemd + service audit |
| R-02 | Release status inconsistency | Medium | High | Product Ops | Canonical release registry |
| R-03 | SEO technical regressions | Medium | High | SEO/Frontend | Contract tests in CI |
| R-04 | Funnel drop-off | Medium | Medium | Product/UX | CRM instrumentation + iteration |
| R-05 | Standards drift between repos | Medium | Medium | Platform Gov | Cross-repo sync + guardrails |

## 14) Execution Log Template

Use this log block for each completed task:

```md
### Task: <TASK_ID>
- Date:
- Owner:
- Repo:
- PR:
- Commands run:
- Evidence:
- Acceptance result: Pass/Fail
- Follow-up actions:
```

## 15) Review Cadence

- Weekly execution review:
  - phase progress
  - blocked tasks
  - risk changes
  - KPI movement
- End-of-phase review:
  - evidence review
  - closure decision
  - next phase kickoff

