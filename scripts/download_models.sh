#!/usr/bin/env bash
# Downloads the Gemma 3n E2B int4 model weights from HuggingFace.
# Requires Wi-Fi (file is ~1.5 GB).

set -euo pipefail

DEST="assets/models/gemma-3n-E2B-it-int4.task"
URL="https://huggingface.co/google/gemma-3n-E2B-it-int4/resolve/main/gemma-3n-E2B-it-int4.task"

if [[ -f "$DEST" ]]; then
  echo "Model already present at $DEST — skipping download."
  exit 0
fi

mkdir -p assets/models
echo "Downloading Gemma 3n E2B int4 (~1.5 GB) — Wi-Fi recommended..."
curl -L --progress-bar "$URL" -o "$DEST"
echo "Download complete: $DEST"
