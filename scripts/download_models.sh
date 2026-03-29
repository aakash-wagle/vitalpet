#!/usr/bin/env bash
# Downloads Gemma 3 1B IT in MediaPipe .task format from Hugging Face.
#
# USAGE:
#   bash scripts/download_models.sh
#
# Paste your Hugging Face token into HF_TOKEN below, or export it in your shell.
# Make sure you have accepted the model license on Hugging Face first.

set -euo pipefail

HF_TOKEN="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"

MODEL_REPO="litert-community/Gemma3-1B-IT"
MODEL_FILE="gemma3-1b-it-int4.task"
DEST="assets/models/${MODEL_FILE}"
URL="https://huggingface.co/${MODEL_REPO}/resolve/main/${MODEL_FILE}"

if [[ -f "$DEST" ]]; then
  echo "✓ Model already present at $DEST — skipping download."
  exit 0
fi

mkdir -p assets/models

echo "⬇ Downloading ${MODEL_FILE} from ${MODEL_REPO} …"

if [[ "$HF_TOKEN" == "YOUR_HUGGINGFACE_TOKEN_HERE" ]]; then
  echo "⚠ HF_TOKEN is still a placeholder."
  echo "  If the repo requires auth, set your token first:"
  echo "  export HF_TOKEN=hf_xxx"
  echo ""
fi

curl -L --fail --progress-bar \
  -H "Authorization: Bearer ${HF_TOKEN}" \
  "$URL" \
  -o "$DEST"

echo ""
echo "✓ Download complete: $DEST"
echo "  Now run: flutter run"