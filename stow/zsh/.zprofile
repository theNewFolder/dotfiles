# Login-shell environment for zsh.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Start X11 automatically on tty1/tty2, but never launch a second X session.
if [[ -z "${DISPLAY:-}" && "${XDG_VTNR:-0}" -le 2 ]]; then
  if ! pgrep -x Xorg >/dev/null 2>&1 && ! pgrep -x X >/dev/null 2>&1; then
    startx
  fi
fi
