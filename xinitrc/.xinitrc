#!/bin/sh
# T490 X11 session startup (repo-guided)

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
export PATH="$HOME/dotfiles/scripts/statusbar:$HOME/dotfiles/scripts:$HOME/.local/bin/statusbar:$HOME/.local/bin:$PATH"
export TERMINAL="${TERMINAL:-kitty}"

# VA-API: use intel-media-driver (iHD) for Whiskey Lake VP9/AV1/H.264 decode
export LIBVA_DRIVER_NAME=iHD
export EDITOR="${EDITOR:-emacsclient -c -a emacs}"
export BROWSER="${BROWSER:-firefox}"

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

# GNOME Keyring — pick up daemon started by PAM (or start it); exports control vars
# for all child processes (Firefox, VSCode, git-credential-helper, etc.)
if command -v gnome-keyring-daemon >/dev/null; then
    eval "$(gnome-keyring-daemon --start --components=secrets,pkcs11 2>/dev/null)"
    export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID
fi

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
command -v mpd >/dev/null && mpd >/dev/null 2>&1 &
command -v dwmblocks >/dev/null && dwmblocks &

# Compositor + wallpaper
if command -v picom >/dev/null; then
  if [ "${PICOM_BACKEND:-glx}" = "xrender" ] && [ -f "$HOME/dotfiles/picom-xrender.conf" ]; then
    picom --config "$HOME/dotfiles/picom-xrender.conf" -b
  elif [ -f "$HOME/.config/picom/picom.conf" ]; then
    picom --config "$HOME/.config/picom/picom.conf" -b
  else
    picom --config "$HOME/dotfiles/picom.conf" -b
  fi
fi

if [ -f "$HOME/.fehbg" ]; then
  . "$HOME/.fehbg"
elif [ -d "$HOME/wallpapers" ]; then
  wall=$(find "$HOME/wallpapers" -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n 1)
  [ -n "$wall" ] && feh --bg-fill "$wall"
fi

exec dwm
