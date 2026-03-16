#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WAN_DIR="${ROOT_DIR}/wan_models/Wan2.1-T2V-1.3B"
LONGLIVE_DIR="${ROOT_DIR}/longlive_models"

if ! command -v hf >/dev/null 2>&1; then
  echo "hf CLI was not found. Install dependencies first, then run: uv sync"
  exit 1
fi

mkdir -p "${WAN_DIR}" "${LONGLIVE_DIR}"

echo "Downloading LongLive weights into ${LONGLIVE_DIR}"
hf download Efficient-Large-Model/LongLive-1.3B \
  --local-dir "${LONGLIVE_DIR}" \
  --repo-type model

echo "Downloading Wan base model into ${WAN_DIR}"
hf download Wan-AI/Wan2.1-T2V-1.3B \
  --local-dir "${WAN_DIR}" \
  --repo-type model

echo "Model download completed."
