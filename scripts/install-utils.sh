#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${ROOT}/scripts/utils"
DST="${HOME}/.local/bin/utils"

mkdir -p "${DST}" "${HOME}/.local/bin"

# Install utility scripts
cp -a "${SRC}/." "${DST}/"
chmod +x "${DST}"/*

# Install fzf-git.sh to ~/.local/bin/
if [ -f "${ROOT}/scripts/fzf-git.sh" ]; then
  cp "${ROOT}/scripts/fzf-git.sh" "${HOME}/.local/bin/fzf-git.sh"
  echo "Installed fzf-git.sh to ~/.local/bin/"
fi

echo "Installed $(ls "${DST}" | wc -l) utility scripts to ${DST}"
