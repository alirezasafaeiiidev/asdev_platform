SHELL := /bin/bash

.PHONY: setup lint test run

setup:
	@command -v git >/dev/null || (echo "git is required" && exit 1)
	@command -v gh >/dev/null || (echo "gh is required" && exit 1)
	@echo "Setup complete."

lint:
	@bash -n platform/scripts/sync.sh
	@bash -n platform/scripts/divergence-report.sh
	@bash -n scripts/monthly-release.sh
	@echo "Lint checks passed."

test:
	@bash tests/test_scripts.sh

run:
	@echo "ASDEV Platform is a standards/governance repository; use scripts under platform/scripts/."
