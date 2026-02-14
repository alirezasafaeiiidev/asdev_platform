# Autopilot Runbook

## Purpose

Run phased execution automatically:

- Finish pending `once` tasks
- Wait 3 minutes
- Continue with `health` checks every few minutes
- If a task fails, run its `fix_command`, then retry automatically
- Log all outcomes and keep execution report updated

## Files

- Orchestrator: `scripts/autopilot-orchestrator.sh`
- Task config: `scripts/autopilot-tasks.tsv`
- Start: `scripts/autopilot-start.sh`
- Stop: `scripts/autopilot-stop.sh`
- Report: `docs/reports/AUTOPILOT_EXECUTION_REPORT.md`
- Logs: `var/autopilot/`

## Task Format

`scripts/autopilot-tasks.tsv` uses:

`task_id|mode|repo_path|command|fix_command`

- `mode`: `once` or `health`
- `fix_command`: use `-` when no automatic remediation exists

## Timers

- `IDLE_SECONDS` (default `180`)
- `POST_COMPLETE_WAIT_SECONDS` (default `180`)
- `HEALTHCHECK_SECONDS` (default `300`)

## Autostart

Use user systemd service:

```bash
make autopilot-install-user-service
```

Remove:

```bash
make autopilot-uninstall-user-service
```
