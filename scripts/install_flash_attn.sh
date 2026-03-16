#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UV_BIN="${UV_BIN:-${HOME}/.local/bin/uv}"
FLASH_ATTN_SPEC="${FLASH_ATTN_SPEC:-flash-attn==2.7.4.post1}"
TORCH_SPEC="${TORCH_SPEC:-}"
TORCHVISION_SPEC="${TORCHVISION_SPEC:-}"
WHEEL_ONLY=0

while (($#)); do
  case "$1" in
    --wheel-only)
      WHEEL_ONLY=1
      ;;
    --help|-h)
      cat <<'EOF'
Usage:
  uv run bash scripts/install_flash_attn.sh [--wheel-only]

Optional environment variables:
  UV_BIN            Path to uv binary
  FLASH_ATTN_SPEC   flash-attn requirement spec
  TORCH_SPEC        Torch version to reinstall before flash-attn
  TORCHVISION_SPEC  Torchvision version to reinstall before flash-attn

Examples:
  uv sync --extra flash_attn
  uv run bash scripts/install_flash_attn.sh

  TORCH_SPEC='torch==2.6.*' \
  TORCHVISION_SPEC='torchvision==0.21.*' \
  uv run bash scripts/install_flash_attn.sh --wheel-only
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
  shift
done

if [[ ! -x "${UV_BIN}" ]]; then
  echo "uv binary not found at ${UV_BIN}" >&2
  exit 1
fi

cd "${ROOT_DIR}"

if [[ -n "${TORCH_SPEC}" ]]; then
  echo "Reinstalling torch stack for flash-attn compatibility"
  if [[ -n "${TORCHVISION_SPEC}" ]]; then
    "${UV_BIN}" pip install "${TORCH_SPEC}" "${TORCHVISION_SPEC}"
  else
    "${UV_BIN}" pip install "${TORCH_SPEC}"
  fi
fi

echo "Python: $("${UV_BIN}" run python -c 'import sys; print(sys.version.split()[0])')"
echo "Torch: $("${UV_BIN}" run python -c 'import torch; print(torch.__version__)')"

if [[ "${WHEEL_ONLY}" -eq 1 ]]; then
  echo "Installing flash-attn from wheel only"
  "${UV_BIN}" pip install --only-binary=:all: "${FLASH_ATTN_SPEC}"
else
  echo "Installing flash-attn (wheel if available, otherwise build)"
  "${UV_BIN}" pip install --no-build-isolation "${FLASH_ATTN_SPEC}"
fi

echo "flash-attn import check"
"${UV_BIN}" run python -c 'import flash_attn; print(getattr(flash_attn, "__version__", "unknown"))'
