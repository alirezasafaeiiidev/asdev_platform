# Human External Actions (Out-of-Repo)

These tasks require human/operator action outside repository code.

## Infrastructure / Server

- Create and verify non-root runtime user on servers (e.g., `deploy`).
- Reload systemd units and verify process ownership after deploy.
- Confirm PM2 runtime uses non-root `PM2_HOME`.
- If persistent local automation is required after reboot, register `scripts/autopilot-orchestrator.sh` in system startup (systemd user unit or process manager).

## DNS / Domain / TLS

- Validate DNS and TLS readiness for production domains.
- Verify cert renewal and HSTS behavior in production environment.
- Complete Google Search Console and Bing Webmaster verification for `alirezasafaeidev.ir` and `persiantoolbox.ir`.
- Register and verify production domains (or subdomains) for `family-rosca` and `nexa-vpn` brand pages before indexation.

## Commercial / Legal

- Finalize consulting contract template signatures/workflow.
- Confirm pricing and payment process with finance/legal constraints.

## Sales / CRM Operations

- Configure CRM destination and notifications for lead intake.
- Assign owner for lead triage SLA and response process.

## Release Governance

- Approve final remote release-tag window and execute final tag action.
- Sign off go/no-go decisions based on release registry evidence.
