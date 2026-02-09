# GitHub API Outage Runbook

This runbook covers triage and recovery steps for GitHub API or CLI failures affecting sync and divergence reporting.

## Scope

Applies to:
- `platform/scripts/sync.sh`
- `platform/scripts/divergence-report.sh`
- `platform/scripts/divergence-report-combined.sh`

## Symptoms

- `gh repo clone` fails or times out.
- `gh pr create` fails intermittently.
- Divergence reports include `clone_failed` rows.

## Triage Checklist

1. Confirm GitHub status and incident notes.
2. Validate `gh auth status` and token scopes.
3. Re-run the failing script with `RETRY_ATTEMPTS=3` (default) and capture logs.
4. If failures persist, capture timestamps and affected repos.

## Recovery Steps

1. Re-run the specific command with increased backoff:
   - `RETRY_ATTEMPTS=5 RETRY_BASE_DELAY=3 bash platform/scripts/sync.sh`
   - `RETRY_ATTEMPTS=5 RETRY_BASE_DELAY=3 bash platform/scripts/divergence-report.sh`
2. If still failing, limit scope to a single repo to verify behavior.
3. Once stable, run the full target set and regenerate reports.
4. Update governance notes with impacted repos and timestamps.

## Rollback / Defer

If GitHub API instability continues:
- Defer `sync.sh` PR creation and note it in the weekly governance digest.
- Keep divergence reporting to a subset of targets to avoid partial data.

## Closeout Criteria

- A full run completes without `clone_failed` rows.
- `sync.sh` can create PRs without manual retries.
- Weekly governance digest reflects the stable state.
