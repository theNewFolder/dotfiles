#!/usr/bin/env bash
set -euo pipefail

backend="${1:-glx}"
display="${DISPLAY:-:0}"
xauth="${XAUTHORITY:-$HOME/.Xauthority}"

case "${backend}" in
  glx)
    conf="$HOME/.config/picom/picom.conf"
    ;;
  xrender)
    conf="$HOME/.config/picom/picom-xrender.conf"
    ;;
  *)
    echo "usage: $0 [glx|xrender]" >&2
    exit 2
    ;;
esac

if [ ! -f "${conf}" ]; then
  echo "config not found: ${conf}" >&2
  exit 1
fi

pkill -x picom 2>/dev/null || true
DISPLAY="${display}" XAUTHORITY="${xauth}" picom --config "${conf}" -b
sleep 0.2

if pgrep -x picom >/dev/null 2>&1; then
  echo "picom backend=${backend} config=${conf}"
else
  echo "picom failed to start with backend=${backend}" >&2
  exit 1
fi
