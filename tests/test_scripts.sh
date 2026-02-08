#!/usr/bin/env bash
set -euo pipefail

bash -n platform/scripts/sync.sh
bash -n platform/scripts/divergence-report.sh
bash tests/test_sync_behavior.sh

echo "Script checks passed."
