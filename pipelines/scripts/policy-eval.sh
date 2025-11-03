#!/usr/bin/env bash
set -euo pipefail

POLICY_DIR="infra/policy"
if [ ! -d "$POLICY_DIR" ]; then
  echo "No policy directory found at $POLICY_DIR" >&2
  exit 1
fi

POLICY_FILES=("$POLICY_DIR"/*.json)
if [ ${#POLICY_FILES[@]} -eq 0 ]; then
  echo "No policy JSON files found in $POLICY_DIR" >&2
  exit 1
fi

# Simple smoke-check: validate JSON files are parseable
for f in "$POLICY_DIR"/*.json; do
  if ! jq empty "$f" >/dev/null 2>&1; then
    echo "Invalid JSON in $f" >&2
    exit 1
  fi
done

echo "Policy-as-code smoke check passed (files present and valid JSON)."
exit 0
