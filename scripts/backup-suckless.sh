#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"
OUT_BASE="${ROOT}/backup/suckless"
SNAP_DIR="${OUT_BASE}/${TS}"
ARCHIVE="${OUT_BASE}/suckless-${TS}.tar.xz"

mkdir -p "${SNAP_DIR}"

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [ -e "${src}" ]; then
    mkdir -p "$(dirname "${dst}")"
    cp -a "${src}" "${dst}"
  fi
}

echo "[1/3] Collecting source/config snapshots..."
copy_if_exists "${ROOT}/suckless/src" "${SNAP_DIR}/src"
copy_if_exists "${ROOT}/suckless/patches" "${SNAP_DIR}/patches"
copy_if_exists "${ROOT}/suckless/source-lock.txt" "${SNAP_DIR}/source-lock.txt"
copy_if_exists "${ROOT}/suckless/patch-profile.txt" "${SNAP_DIR}/patch-profile.txt"
copy_if_exists "${ROOT}/suckless/dwm/config.h" "${SNAP_DIR}/config/dwm/config.h"
copy_if_exists "${ROOT}/suckless/dmenu/config.h" "${SNAP_DIR}/config/dmenu/config.h"
copy_if_exists "${ROOT}/suckless/st/config.h" "${SNAP_DIR}/config/st/config.h"
copy_if_exists "${ROOT}/suckless/dwmblocks/blocks.h" "${SNAP_DIR}/config/dwmblocks/blocks.h"

echo "[2/3] Writing build metadata..."
{
  echo "timestamp=${TS}"
  echo "host=$(hostname)"
  echo "kernel=$(uname -r)"
  echo "user=$(id -un)"
} > "${SNAP_DIR}/meta.txt"

echo "[3/3] Creating compressed archive..."
tar -C "${OUT_BASE}" -cJf "${ARCHIVE}" "${TS}"
echo "Backup complete:"
echo "  snapshot dir: ${SNAP_DIR}"
echo "  archive:      ${ARCHIVE}"
