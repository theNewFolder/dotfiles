#!/bin/sh
# T490 X11 session startup (repo-guided)

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
export PATH="$HOME/dotfiles/scripts/statusbar:$HOME/dotfiles/scripts:$HOME/.local/bin/statusbar:$HOME/.local/bin:$PATH"

# Keyboard remaps (LARBS-style): caps/menu behavior + repeat tuning
command -v remaps >/dev/null && remaps &
command -v remapd >/dev/null && remapd &

# Touchpad defaults for ThinkPad
xinput --list --name-only | grep -i touchpad | while read -r dev; do
  xinput set-prop "$dev" "libinput Tapping Enabled" 1 2>/dev/null || true
  xinput set-prop "$dev" "libinput Natural Scrolling Enabled" 1 2>/dev/null || true
done &

# Keep mouse acceleration profile predictable
xinput --list --name-only | grep -i mouse | while read -r dev; do
  xinput set-prop "$dev" "libinput Accel Profile Enabled" 0 1 2>/dev/null || true
done &

# User runit services (ssh-agent, emacs, syncthing)
export SVDIR="$HOME/.local/sv"
export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
mkdir -p "$SVDIR" "$HOME/.ssh"
ln -sf "$HOME/dotfiles/runit/ssh-agent" "$SVDIR/" 2>/dev/null
ln -sf "$HOME/dotfiles/runit/emacs" "$SVDIR/" 2>/dev/null
ln -sf "$HOME/dotfiles/runit/syncthing" "$SVDIR/" 2>/dev/null
runsvdir "$SVDIR" &

# User daemons
command -v clipmenud >/dev/null && clipmenud &
command -v dunst >/dev/null && dunst &
command -v unclutter >/dev/null && unclutter &
command -v mpd >/dev/null && mpd &
command -v dwmblocks >/dev/null && dwmblocks &

# Compositor + wallpaper
if command -v picom >/dev/null; then
  PICOM_CONF="$HOME/dotfiles/picom.conf"
  if [ "${PICOM_BACKEND:-glx}" = "xrender" ] && [ -f "$HOME/dotfiles/picom-xrender.conf" ]; then
    PICOM_CONF="$HOME/dotfiles/picom-xrender.conf"
  fi
  picom --config "$PICOM_CONF" -b
fi

if [ -f "$HOME/.fehbg" ]; then
  . "$HOME/.fehbg"
elif [ -d "$HOME/wallpapers" ]; then
  wall=$(find "$HOME/wallpapers" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)
  [ -n "$wall" ] && feh --bg-fill "$wall"
fi

exec dwm
