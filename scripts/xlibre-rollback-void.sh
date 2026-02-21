#!/usr/bin/env bash
set -euo pipefail

log() { printf '[xlibre-rollback] %s\n' "$*"; }
warn() { printf '[xlibre-rollback][warn] %s\n' "$*" >&2; }
die() { printf '[xlibre-rollback][error] %s\n' "$*" >&2; exit 1; }

if ! command -v xbps-install >/dev/null 2>&1; then
  die "This script targets Void Linux (xbps)."
fi

if ! command -v sudo >/dev/null 2>&1; then
  die "sudo is required."
fi

STATE_FILE="/var/lib/xlibre-migration/latest.env"

if [ ! -f "${STATE_FILE}" ]; then
  die "No migration state file found at ${STATE_FILE}."
fi

# shellcheck disable=SC1090
source "${STATE_FILE}"

[ -n "${BACKUP_DIR:-}" ] || die "BACKUP_DIR missing in ${STATE_FILE}."
[ -d "${BACKUP_DIR}" ] || die "Backup directory not found: ${BACKUP_DIR}."

log "Reinstalling original Xorg packages..."
if [ -f "${BACKUP_DIR}/original-packages.txt" ]; then
  mapfile -t pkgs < <(awk 'NF' "${BACKUP_DIR}/original-packages.txt" | sort -u)
  if [ "${#pkgs[@]}" -gt 0 ]; then
    sudo xbps-install -Sf "${pkgs[@]}"
  else
    warn "No package list in backup, falling back to xorg-minimal."
    sudo xbps-install -Sf xorg-minimal
  fi
else
  warn "No original-packages.txt in backup, falling back to xorg-minimal."
  sudo xbps-install -Sf xorg-minimal
fi

if [ -d "${BACKUP_DIR}/etc/X11" ]; then
  log "Restoring /etc/X11 backup..."
  sudo rm -rf /etc/X11
  sudo mkdir -p /etc
  sudo cp -a "${BACKUP_DIR}/etc/X11" /etc/X11
fi

log "Restoring key X binaries if backups exist..."
for p in /usr/bin/X /usr/bin/Xorg /usr/libexec/Xorg; do
  rel="${p#/}"
  src="${BACKUP_DIR}/${rel}"
  if [ -e "${src}" ]; then
    sudo mkdir -p "$(dirname "${p}")"
    sudo cp -a "${src}" "${p}"
  fi
done

cat <<EOF

Rollback completed.

Next steps:
  1) Reconfigure all packages:
       sudo xbps-reconfigure -fa
  2) Reboot:
       sudo reboot

EOF
