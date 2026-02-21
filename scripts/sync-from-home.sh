#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNAP_ROOT="${REPO_ROOT}/backup/home"

mkdir -p "${SNAP_ROOT}"

copy_if_exists() {
  local rel="$1"
  local src="${HOME}/${rel}"
  local dst="${SNAP_ROOT}/${rel}"

  if [ -e "${src}" ]; then
    mkdir -p "$(dirname "${dst}")"
    cp -a "${src}" "${dst}"
    echo "synced: ${rel}"
  fi
}

# Core shell/X
copy_if_exists ".xinitrc"
copy_if_exists ".Xresources"
copy_if_exists ".zshrc"
copy_if_exists ".zprofile"

# Emacs
copy_if_exists ".emacs.d/init.el"
copy_if_exists ".emacs.d/early-init.el"

# Desktop components
copy_if_exists ".config/picom/picom.conf"
copy_if_exists ".config/dunst/dunstrc"

# Cursor (optional, if present)
copy_if_exists ".config/Cursor/User/settings.json"
copy_if_exists ".config/Cursor/User/keybindings.json"

# Optional local suckless source trees
copy_if_exists "suckless/dwm/config.h"
copy_if_exists "suckless/st/config.h"
copy_if_exists "suckless/dmenu/config.h"
copy_if_exists "suckless/dwmblocks/blocks.h"

# Include common config-based suckless paths
copy_if_exists ".config/suckless/dwm/config.h"
copy_if_exists ".config/suckless/st/config.h"
copy_if_exists ".config/suckless/dmenu/config.h"
copy_if_exists ".config/suckless/dwmblocks/blocks.h"

echo "Backup sync complete: ${SNAP_ROOT}"
