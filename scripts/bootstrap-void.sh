#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v xbps-install >/dev/null 2>&1; then
  echo "This bootstrap script targets Void Linux (xbps)." >&2
  exit 1
fi

echo "[1/8] Updating package index and system..."
sudo xbps-install -Su
sudo xbps-install -Su

echo "[2/8] Installing base packages..."
BASE_PKGS=(
  base-devel git curl wget stow
  xorg-minimal xinit setxkbmap xrandr xinput xsetroot
  libX11-devel libXft-devel libXinerama-devel freetype-devel fontconfig-devel libxcb-devel
  dwm dmenu st slstatus
  dunst picom feh scrot xclip clipmenu xss-lock brightnessctl slock unclutter
  kitty
  zsh zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
  fzf zoxide fd ripgrep
  emacs-gtk3
  mpd mpc ncmpcpp
  pipewire wireplumber
  tlp thermald powertop
  intel-ucode linux-firmware-intel fwupd
  NetworkManager network-manager-applet
  elogind polkit dbus
  xtools xcape xdotool
  numfmt
)

sudo xbps-install -Sy "${BASE_PKGS[@]}"

echo "[3/8] Enabling runit services..."
enable_service() {
  local svc="$1"
  if [ ! -d "/etc/sv/${svc}" ]; then
    echo "  - skip ${svc} (service directory missing)"
    return 0
  fi
  if [ -L "/var/service/${svc}" ]; then
    echo "  - ${svc} already enabled"
    return 0
  fi
  sudo ln -s "/etc/sv/${svc}" "/var/service/${svc}"
  echo "  - enabled ${svc}"
}

enable_service dbus
enable_service elogind
enable_service NetworkManager
enable_service tlp
enable_service thermald

if [ -L /var/service/acpid ]; then
  echo "  - disabling acpid to avoid ACPI event conflicts with elogind"
  sudo rm -f /var/service/acpid
fi

echo "[4/8] Applying T490 battery-first TLP profile (75/85)..."
sudo mkdir -p /etc/tlp.d
sudo tee /etc/tlp.d/10-t490-battery-first.conf > /dev/null <<'EOF'
# ThinkPad T490 battery-first profile
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=85
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power
CPU_BOOST_ON_BAT=0
WIFI_PWR_ON_BAT=on
PCIE_ASPM_ON_BAT=powersupersave
RUNTIME_PM_ON_BAT=auto
EOF
sudo sv restart tlp || true

echo "[5/8] XLibre path..."
if [ "${USE_XLIBRE:-0}" = "1" ]; then
  echo "  - USE_XLIBRE=1 set, running aggressive XLibre migration."
  bash "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/xlibre-migrate-void.sh"
else
  echo "  - Skipping XLibre migration in bootstrap."
  echo "  - To migrate later:"
  echo "      bash ~/dotfiles/scripts/xlibre-migrate-void.sh"
fi

echo "[6/8] Post-install sanity..."
sudo xbps-reconfigure -fa

echo "[7/8] Linking zsh defaults..."
if [ -f "${ROOT}/zsh/.zshrc" ]; then
  ln -sf "${ROOT}/zsh/.zshrc" "${HOME}/.zshrc"
  echo "  - linked ~/.zshrc"
fi
if [ -f "${ROOT}/zsh/.zprofile" ]; then
  ln -sf "${ROOT}/zsh/.zprofile" "${HOME}/.zprofile"
  echo "  - linked ~/.zprofile"
fi

echo "[8/8] Done."
cat <<'EOF'

Next:
  1) Reboot.
  2) Verify services:
       sudo sv status dbus elogind NetworkManager tlp thermald
  3) Validate battery profile:
       sudo tlp-stat -s -b
  4) Run power audit:
       sudo powertop --calibrate
       sudo powertop --auto-tune-dump
  5) Optional aggressive XLibre migration:
       USE_XLIBRE=1 bash ~/dotfiles/scripts/bootstrap-void.sh
       # or run directly:
       bash ~/dotfiles/scripts/xlibre-migrate-void.sh
  6) Roll back to Xorg if needed:
       bash ~/dotfiles/scripts/xlibre-rollback-void.sh
  7) Confirm zsh default shell:
       chsh -s "$(command -v zsh)"
  8) Start X11 session:
       startx

EOF
