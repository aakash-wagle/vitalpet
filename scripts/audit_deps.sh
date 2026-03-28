#!/bin/bash
# audit_deps.sh — confirms no banned analytics/advertising packages in pubspec.yaml

BANNED=("firebase_analytics" "amplitude_flutter" "mixpanel_flutter" "segment_analytics" "appsflyer" "adjust_sdk" "facebook_audience_network")
FOUND=0

for pkg in "${BANNED[@]}"; do
  if grep -q "$pkg" pubspec.yaml; then
    echo "FAIL: Banned package found: $pkg"
    FOUND=1
  fi
done

if [ $FOUND -eq 0 ]; then
  echo "PASS: No banned analytics or advertising packages found."
fi

exit $FOUND
