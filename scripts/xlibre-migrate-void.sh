#!/usr/bin/env bash
set -euo pipefail

log() { printf '[xlibre-migrate] %s\n' "$*"; }
warn() { printf '[xlibre-migrate][warn] %s\n' "$*" >&2; }
die() { printf '[xlibre-migrate][error] %s\n' "$*" >&2; exit 1; }

if ! command -v xbps-install >/dev/null 2>&1; then
  die "This script targets Void Linux (xbps)."
fi

if ! command -v sudo >/dev/null 2>&1; then
  die "sudo is required."
fi

BUILD_ROOT="${XLIBRE_BUILD_ROOT:-$HOME/.local/src/xlibre-build}"
STATE_DIR="/var/lib/xlibre-migration"
BACKUP_ROOT="/var/backups/xlibre"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
WORKDIR="${BUILD_ROOT}/${TS}"
BACKUP_DIR="${BACKUP_ROOT}/${TS}"
STATE_FILE="${STATE_DIR}/latest.env"
XORG_PROFILE="${XLIBRE_XORG_PROFILE:-$HOME/dotfiles/xorg/20-intel-modesetting.conf}"

# Build flags tuned for local hardware; override via environment if needed.
CFLAGS_DEFAULT='-O2 -pipe -march=native -mtune=native'
LDFLAGS_DEFAULT='-Wl,-O1'
export CFLAGS="${CFLAGS:-$CFLAGS_DEFAULT}"
export CXXFLAGS="${CXXFLAGS:-$CFLAGS_DEFAULT}"
export LDFLAGS="${LDFLAGS:-$LDFLAGS_DEFAULT}"

mkdir -p "${WORKDIR}"

backup_path() {
  local p="$1"
  [ -e "${p}" ] || return 0
  local rel="${p#/}"
  local dst="${BACKUP_DIR}/${rel}"
  sudo mkdir -p "$(dirname "${dst}")"
  sudo cp -a "${p}" "${dst}"
}

detect_owner_pkg() {
  local p="$1"
  xbps-query -o "${p}" 2>/dev/null | awk 'NR==1{print $1}'
}

install_build_tools() {
  log "Installing base build tooling..."
  sudo xbps-install -Sy \
    base-devel git curl pkg-config meson ninja \
    autoconf automake libtool
}

build_xserver() {
  log "Cloning XLibre xserver..."
  git clone --depth=1 https://github.com/X11Libre/xserver.git "${WORKDIR}/xserver"

  log "Configuring XLibre xserver (prefix=/usr, CFLAGS=${CFLAGS})..."
  meson setup "${WORKDIR}/xserver/build" "${WORKDIR}/xserver" \
    --buildtype=release \
    --prefix=/usr \
    --sysconfdir=/etc/X11 \
    --localstatedir=/var

  log "Building XLibre xserver..."
  ninja -C "${WORKDIR}/xserver/build"

  log "Installing XLibre xserver..."
  sudo ninja -C "${WORKDIR}/xserver/build" install
}

build_input_driver() {
  log "Cloning XLibre xf86-input-libinput..."
  git clone --depth=1 https://github.com/X11Libre/xf86-input-libinput.git "${WORKDIR}/xf86-input-libinput"

  if [ -f "${WORKDIR}/xf86-input-libinput/meson.build" ]; then
    log "Building xf86-input-libinput via meson..."
    meson setup "${WORKDIR}/xf86-input-libinput/build" "${WORKDIR}/xf86-input-libinput" \
      --buildtype=release \
      --prefix=/usr
    ninja -C "${WORKDIR}/xf86-input-libinput/build"
    sudo ninja -C "${WORKDIR}/xf86-input-libinput/build" install
    return 0
  fi

  if [ -f "${WORKDIR}/xf86-input-libinput/autogen.sh" ]; then
    log "Building xf86-input-libinput via autotools..."
    (
      cd "${WORKDIR}/xf86-input-libinput"
      NOCONFIGURE=1 ./autogen.sh
      ./configure --prefix=/usr
      make -j"$(nproc)"
      sudo make install
    )
    return 0
  fi

  warn "xf86-input-libinput build system not recognized; skipping driver build."
}

install_intel_profile() {
  if [ ! -f "${XORG_PROFILE}" ]; then
    warn "Intel modesetting profile not found: ${XORG_PROFILE}"
    return 0
  fi

  log "Installing Intel modesetting profile..."
  sudo mkdir -p /etc/X11/xorg.conf.d
  sudo cp -f "${XORG_PROFILE}" /etc/X11/xorg.conf.d/20-intel-modesetting.conf
}

capture_state() {
  local xserver_commit
  local input_commit
  xserver_commit="$(git -C "${WORKDIR}/xserver" rev-parse --short=12 HEAD)"
  input_commit="$(git -C "${WORKDIR}/xf86-input-libinput" rev-parse --short=12 HEAD 2>/dev/null || echo "unknown")"

  sudo mkdir -p "${STATE_DIR}" "${BACKUP_DIR}"
  sudo tee "${STATE_FILE}" >/dev/null <<EOF
TIMESTAMP=${TS}
WORKDIR=${WORKDIR}
BACKUP_DIR=${BACKUP_DIR}
XSERVER_COMMIT=${xserver_commit}
INPUT_COMMIT=${input_commit}
EOF
}

log "Backing up current X stack state..."
sudo mkdir -p "${BACKUP_DIR}"
backup_path /usr/bin/X
backup_path /usr/bin/Xorg
backup_path /usr/libexec/Xorg
backup_path /etc/X11

{
  detect_owner_pkg /usr/bin/X
  detect_owner_pkg /usr/bin/Xorg
  detect_owner_pkg /usr/libexec/Xorg
} | awk 'NF' | sort -u | sudo tee "${BACKUP_DIR}/original-packages.txt" >/dev/null || true

install_build_tools

log "Starting aggressive migration to XLibre (replaces active X server stack)..."
build_xserver
build_input_driver
install_intel_profile
capture_state

cat <<EOF

XLibre migration completed.

State:
  ${STATE_FILE}
Backup:
  ${BACKUP_DIR}

If graphics fail after reboot/login:
  1) Switch to TTY (Ctrl+Alt+F2)
  2) Run: bash ~/dotfiles/scripts/xlibre-rollback-void.sh
  3) Reboot

EOF
