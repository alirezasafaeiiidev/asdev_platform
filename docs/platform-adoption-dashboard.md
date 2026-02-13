# Platform Adoption Dashboard

- Generated at: 2026-02-13T11:33:51Z
## Level 0 Adoption (from divergence report)

| Repository | Aligned | Diverged | Missing | Opted-out |
|---|---:|---:|---:|---:|
| alirezasafaeiiidev/asdev-creator-membership-ir | 2 | 5 | 2 | 1 |
| alirezasafaeiiidev/asdev-nexa-vpn | 0 | 0 | 10 | 0 |
| alirezasafaeiiidev/asdev-persiantoolbox | 2 | 7 | 2 | 0 |
| alirezasafaeiiidev/asdev-portfolio | 0 | 4 | 6 | 0 |

## Level 0 Trend (Current vs Previous Snapshot)

| Status | Previous | Current | Delta |
|---|---:|---:|---:|
| aligned | 21 | 4 | -17 |
| diverged | 0 | 16 | 16 |
| missing | 0 | 20 | 20 |
| opted_out | 1 | 1 | 0 |

## Combined Report Trend (Current vs Previous Snapshot)

| Status | Previous | Current | Delta |
|---|---:|---:|---:|
| aligned | 12 | 6 | -6 |
| diverged | 19 | 25 | 6 |
| missing | 3 | 25 | 22 |
| opted_out | 1 | 1 | 0 |
| clone_failed | 1 | 0 | -1 |
| unknown_template | 0 | 0 | 0 |
| unknown | 0 | 0 | 0 |

## Combined Reliability (clone_failed)

| Metric | Previous | Current | Delta |
|---|---:|---:|---:|
| clone_failed rows | 1 | 0 | -1 |

### clone_failed Trend by Run

| Run | clone_failed rows |
|---|---:|
| 20260209T100000Z | 2 |
| 20260210T134011Z | 2 |
| 20260210T183518Z | 0 |
| 20260213T113021Z | 1 |
| current | 0 |
| previous | 1 |

### unknown_template Trend by Run

| Run | unknown_template rows |
|---|---:|
| 20260209T100000Z | 1 |
| 20260210T134011Z | 0 |
| 20260210T183518Z | 0 |
| 20260213T113021Z | 0 |
| current | 0 |
| previous | 0 |

### clone_failed by Repository

| Repository | Previous | Current | Delta |
|---|---:|---:|---:|
| alirezasafaeiiidev/python-level1-pilot | 1 | 0 | -1 |

## Transient Error Fingerprints (Combined)

| Fingerprint | Previous | Current | Delta |
|---|---:|---:|---:|
| auth_or_access | 1 | 0 | -1 |

## Top Fingerprint Deltas (Current Run)

### Top Positive Deltas

| Fingerprint | Delta |
|---|---:|
| none | 0 |

### Top Negative Deltas

| Fingerprint | Delta |
|---|---:|
| auth_or_access | -1 |

## Fingerprint Delta History (Recent Runs)

| Run | Fingerprint | Delta |
|---|---|---:|
| 20260210T134011Z | auth_or_access | 3 |
| 20260210T134011Z | timeout | -1 |
| 20260210T134011Z | tls_error | 2 |
| 20260210T183518Z | auth_or_access | -2 |
| 20260213T113021Z | auth_or_access | 0 |
| current | auth_or_access | -1 |
| previous | auth_or_access | 0 |

## auth_or_access Trend by Run

| Run | auth_or_access count |
|---|---:|
| 20260209T100000Z | 3 |
| 20260210T134011Z | 4 |
| 20260210T183518Z | 0 |
| 20260213T113021Z | 1 |
| current | 0 |
| previous | 1 |

## timeout Trend by Run

| Run | timeout count |
|---|---:|
| 20260209T100000Z | 5 |
| 20260210T134011Z | 1 |
| 20260210T183518Z | 0 |
| 20260213T113021Z | 0 |
| current | 0 |
| previous | 0 |

## Combined Report Delta by Repo

| Repository | Previous Non-aligned | Current Non-aligned | Delta |
|---|---:|---:|---:|
| alirezasafaeiiidev/asdev-creator-membership-ir | 0 | 14 | 14 |
| alirezasafaeiiidev/asdev-nexa-vpn | 0 | 10 | 10 |
| alirezasafaeiiidev/asdev-persiantoolbox | 0 | 13 | 13 |
| alirezasafaeiiidev/asdev-portfolio | 0 | 14 | 14 |
| alirezasafaeiiidev/go-level1-pilot | 1 | 0 | -1 |
| alirezasafaeiiidev/my_portfolio | 7 | 0 | -7 |
| alirezasafaeiiidev/patreon_iran | 8 | 0 | -8 |
| alirezasafaeiiidev/persian_tools | 7 | 0 | -7 |
| alirezasafaeiiidev/python-level1-pilot | 1 | 0 | -1 |

## Level 1 Rollout Targets

| Repository | Level 1 Templates | Target File |
|---|---|---|
|  |  | sync/targets.level1.go.yaml |
| alirezasafaeiiidev/asdev-creator-membership-ir | js-ts-level1-ci, agents-runtime-guidance, codex-automation-spec | sync/targets.level1.patreon.yaml |
|  |  | sync/targets.level1.python.yaml |
| alirezasafaeiiidev/asdev-portfolio | js-ts-level1-ci, agents-runtime-guidance, codex-automation-spec | sync/targets.level1.yaml |
| alirezasafaeiiidev/asdev-persiantoolbox | js-ts-level1-ci, agents-runtime-guidance, codex-automation-spec | sync/targets.level1.yaml |
| alirezasafaeiiidev/asdev-creator-membership-ir | js-ts-level1-ci, agents-runtime-guidance, codex-automation-spec | sync/targets.level1.yaml |

## Notes

- Level 0 metrics are derived from `sync/divergence-report.csv`.
- Level 1 section reflects configured rollout intent from `sync/targets.level1*.yaml`.
