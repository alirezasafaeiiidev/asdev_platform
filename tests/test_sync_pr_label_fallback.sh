#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

YQ_BIN="$("${ROOT_DIR}/scripts/ensure-yq.sh")"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "${WORK_DIR}"' EXIT

FAKE_BIN="${WORK_DIR}/fakebin"
FAKE_GH_ROOT="${WORK_DIR}/fake-gh-repos"
REMOTE_ROOT="${WORK_DIR}/remote-repos"
mkdir -p "${FAKE_BIN}" "${FAKE_GH_ROOT}" "${REMOTE_ROOT}" "${WORK_DIR}/sync"

cat > "${FAKE_BIN}/gh" << 'GH'
#!/usr/bin/env bash
set -euo pipefail

if [[ "${1:-}" == "repo" && "${2:-}" == "clone" ]]; then
  repo="${3:-}"
  dest="${4:-}"
  key="${repo//\//__}"
  cp -a "${FAKE_GH_ROOT}/${key}" "${dest}"
  exit 0
fi

if [[ "${1:-}" == "pr" && "${2:-}" == "create" ]]; then
  if [[ " $* " == *" --label "* ]]; then
    echo "could not add label: 'asdev-sync' not found" >&2
    exit 1
  fi
  echo "https://example.invalid/pr/3"
  exit 0
fi

exit 0
GH
chmod +x "${FAKE_BIN}/gh"

REPO_KEY="local__repo-three"
TARGET_REPO="${FAKE_GH_ROOT}/${REPO_KEY}"
REMOTE_REPO="${REMOTE_ROOT}/${REPO_KEY}.git"
mkdir -p "${TARGET_REPO}" "${REMOTE_REPO}"

(
  cd "${REMOTE_REPO}"
  git init -q --bare
)

(
  cd "${TARGET_REPO}"
  git init -q
  git checkout -b main >/dev/null
  git config user.name "asdev-test"
  git config user.email "asdev-test@example.com"
  git remote add origin "${REMOTE_REPO}"
  echo "# repo-three" > README.md
  git add README.md
  git commit -q -m "test: initial"
  git push -u origin main >/dev/null
)

cat > "${WORK_DIR}/sync/targets-test.yaml" << 'YAML'
targets:
  - repo: local/repo-three
    default_branch: main
    templates:
      - js-ts-level1-ci
    optional_features: []
    opt_outs: []
    labels:
      - asdev-sync
YAML

OUTPUT_FILE="${WORK_DIR}/sync.out"
(
  cd "${WORK_DIR}"
  export FAKE_GH_ROOT
  PATH="${FAKE_BIN}:$(dirname "${YQ_BIN}"):${PATH}" \
  bash "${ROOT_DIR}/platform/scripts/sync.sh" \
    sync/targets-test.yaml \
    "${ROOT_DIR}/platform/repo-templates/templates.yaml" \
    "${ROOT_DIR}/platform/repo-templates"
) | tee "${OUTPUT_FILE}"

if ! grep -q "PR create with labels failed for local/repo-three. Retrying without labels..." "${OUTPUT_FILE}"; then
  echo "Expected PR label fallback message not found" >&2
  exit 1
fi

if ! grep -q "PR created for local/repo-three" "${OUTPUT_FILE}"; then
  echo "Expected PR creation after fallback" >&2
  exit 1
fi

if ! grep -q "Sync summary -> success: 1, failed: 0, skipped: 0" "${OUTPUT_FILE}"; then
  echo "Unexpected summary for label fallback case" >&2
  exit 1
fi

echo "sync PR label fallback checks passed."
