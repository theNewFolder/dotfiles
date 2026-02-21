#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${ROOT}/scripts/statusbar"
DST="${HOME}/.local/bin/statusbar"

mkdir -p "${DST}"
cp -a "${SRC}/." "${DST}/"
chmod +x "${DST}"/sb-*

echo "Installed status scripts to ${DST}"
