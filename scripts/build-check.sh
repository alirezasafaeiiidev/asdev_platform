#!/usr/bin/env bash
set -euo pipefail

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

archive_file="${work_dir}/asdev-standards-platform.tar"

git archive --format=tar HEAD > "$archive_file"

if [[ ! -s "$archive_file" ]]; then
  echo "Build artifact generation failed: empty archive" >&2
  exit 1
fi

required_paths=(
  "README.md"
  "Makefile"
  "scripts/"
  "tests/"
)

archive_listing="${work_dir}/archive.lst"
tar -tf "$archive_file" > "$archive_listing"

for required in "${required_paths[@]}"; do
  if ! grep -q "^${required}" "$archive_listing"; then
    echo "Build integrity failure: missing ${required} in archive" >&2
    exit 1
  fi
done

echo "Build checks passed."
