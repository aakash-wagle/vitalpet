#!/usr/bin/env bash
# Checks pubspec.yaml for banned analytics/advertising packages.
# Exits 1 if any are found.

set -euo pipefail

PUBSPEC="${1:-pubspec.yaml}"
BANNED=(firebase_analytics amplitude_flutter mixpanel_flutter segment_analytics)

FOUND=0
for pkg in "${BANNED[@]}"; do
  if grep -qE "^\s*${pkg}:" "$PUBSPEC"; then
    echo "ERROR: banned package found in ${PUBSPEC}: ${pkg}" >&2
    FOUND=1
  fi
done

if [[ $FOUND -eq 1 ]]; then
  echo "Audit FAILED — remove banned packages before releasing." >&2
  exit 1
fi

echo "Audit PASSED — no banned packages found in ${PUBSPEC}."
