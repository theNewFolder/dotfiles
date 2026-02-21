#!/usr/bin/env bash
set -euo pipefail

log() { printf '[emacs-git] %s\n' "$*"; }
die() { printf '[emacs-git][error] %s\n' "$*" >&2; exit 1; }

if ! command -v xbps-install >/dev/null 2>&1; then
  die "This script targets Void Linux (xbps)."
fi

BRANCH="${EMACS_BRANCH:-master}"
PREFIX="${EMACS_PREFIX:-/usr/local}"
SRC_ROOT="${EMACS_SRC_ROOT:-$HOME/.local/src/emacs}"
JOBS="${EMACS_JOBS:-$(nproc)}"

# T490-focused build defaults (override via env if needed)
CFLAGS_DEFAULT='-O2 -pipe -march=native -mtune=native -fomit-frame-pointer'
LDFLAGS_DEFAULT='-Wl,-O1'
export CFLAGS="${CFLAGS:-$CFLAGS_DEFAULT}"
export LDFLAGS="${LDFLAGS:-$LDFLAGS_DEFAULT}"

install_deps() {
  log "Installing Emacs build dependencies..."
  sudo xbps-install -Sy \
    git gcc make pkg-config autoconf automake texinfo \
    libgccjit-devel jansson-devel tree-sitter-devel sqlite-devel \
    gnutls-devel libxml2-devel ncurses-devel \
    cairo-devel harfbuzz-devel pango-devel gtk+3-devel \
    libjpeg-turbo-devel libpng-devel giflib-devel libtiff-devel
}

sync_source() {
  mkdir -p "$(dirname "$SRC_ROOT")"
  if [ -d "${SRC_ROOT}/.git" ]; then
    log "Updating existing Emacs source..."
    git -C "${SRC_ROOT}" fetch --tags --prune origin
  else
    log "Cloning Emacs source..."
    git clone https://git.savannah.gnu.org/git/emacs.git "${SRC_ROOT}"
  fi

  git -C "${SRC_ROOT}" checkout "${BRANCH}"
  git -C "${SRC_ROOT}" reset --hard "origin/${BRANCH}" || true
}

build_install() {
  log "Running autogen..."
  (cd "${SRC_ROOT}" && ./autogen.sh)

  log "Configuring Emacs..."
  (cd "${SRC_ROOT}" && ./configure \
    --prefix="${PREFIX}" \
    --with-native-compilation=aot \
    --with-json \
    --with-tree-sitter \
    --with-modules \
    --with-cairo \
    --with-harfbuzz \
    --with-x-toolkit=gtk3 \
    --with-threads \
    --without-compress-install)

  log "Building Emacs (jobs=${JOBS})..."
  (cd "${SRC_ROOT}" && make -j"${JOBS}")

  log "Installing Emacs to ${PREFIX}..."
  (cd "${SRC_ROOT}" && sudo make install)
}

verify() {
  local bin="${PREFIX}/bin/emacs"
  if [ ! -x "${bin}" ]; then
    die "Install finished but ${bin} not found."
  fi

  log "Verifying build features..."
  "${bin}" --batch --eval "(princ (format \"emacs=%s native=%s tree-sitter=%s json=%s\\n\"
    emacs-version
    (if (fboundp 'native-comp-available-p) (native-comp-available-p) 'unknown)
    (if (fboundp 'treesit-available-p) (treesit-available-p) 'unknown)
    (if (fboundp 'json-serialize) t nil)))"
}

install_deps
sync_source
build_install
verify

cat <<EOF

Done.

Recommended daemon startup:
  emacs --daemon
  emacsclient -c -a emacs

EOF
