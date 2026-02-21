#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_ROOT="${ROOT}/suckless/src"
PATCH_ROOT="${ROOT}/suckless/patches/dwm"
PATCH_ROOT_DWMBLOCKS="${ROOT}/suckless/patches/dwmblocks"

PATCHES=(
  "dwm-cfacts-vanitygaps-6.4_combo.diff"
  "dwm-pertag_with_sel-20231003-9f88553.diff"
  "dwm-autostart-20210120-cb3f58a.diff"
  "dwm-hide_vacant_tags-6.4.diff"
  "dwm-actualfullscreen-20211013-cb3f58a.diff"
  "dwm-movestack-20211115-a786211.diff"
  "dwm-barpadding-6.6.diff"
  "dwm-statuscmd-20260124-a9aa0d8.diff"
  "dwm-alpha-20250918-74edc27.diff"
  "dwm-status2d-barpadding-20241018-44e9799.diff"
)

ensure_sources() {
  if [ ! -d "${SRC_ROOT}/dwm/.git" ]; then
    bash "${ROOT}/scripts/fetch-suckless-sources.sh"
  fi
}

checkout_latest() {
  local dir="$1"
  local branch=""
  local remote_head=""

  git -C "${dir}" fetch --tags --prune origin
  remote_head="$(git -C "${dir}" symbolic-ref --quiet refs/remotes/origin/HEAD || true)"
  branch="${remote_head#refs/remotes/origin/}"
  [ -n "${branch}" ] || branch="master"

  if git -C "${dir}" show-ref --verify --quiet "refs/heads/${branch}"; then
    git -C "${dir}" checkout "${branch}"
  else
    git -C "${dir}" checkout -B "${branch}" "origin/${branch}"
  fi

  git -C "${dir}" reset --hard "origin/${branch}" || true
  git -C "${dir}" clean -fd
}

prepare_dwm() {
  local dir="${SRC_ROOT}/dwm"
  checkout_latest "${dir}"

  for p in "${PATCHES[@]}"; do
    if ! patch -d "${dir}" -p1 < "${PATCH_ROOT}/${p}"; then
      case "${p}" in
        dwm-movestack-20211115-a786211.diff)
          echo "warn: ${p} had non-critical rejects (continuing)" >&2
          ;;
        dwm-statuscmd-20260124-a9aa0d8.diff)
          echo "warn: ${p} had known partial rejects (continuing with compat patch)" >&2
          ;;
        dwm-alpha-20250918-74edc27.diff)
          echo "warn: ${p} had known partial rejects (applying fixups)" >&2
          ;;
        dwm-status2d-barpadding-20241018-44e9799.diff)
          echo "warn: ${p} had known partial rejects (continuing with compat)" >&2
          ;;
        *)
          echo "error: failed to apply ${p}" >&2
          exit 1
          ;;
      esac
    fi
  done

  patch -d "${dir}" -p1 < "${PATCH_ROOT}/dwm-statuscmd-barpadding-compat.diff"

  # Fix rejected alpha-patch hunks directly (drw.c, drw.h, dwm.c)
  echo "  applying alpha compat fixups..."

  # drw.h: add alpha param to declarations
  sed -i 's/^void drw_clr_create(Drw \*drw, Clr \*dest, const char \*clrname);$/void drw_clr_create(Drw *drw, Clr *dest, const char *clrname, unsigned int alpha);/' "${dir}/drw.h"
  sed -i 's/^Clr \*drw_scm_create(Drw \*drw, const char \*clrnames\[\], size_t clrcount);$/Clr *drw_scm_create(Drw *drw, const char *clrnames[], const unsigned int clralphas[], size_t clrcount);/' "${dir}/drw.h"

  # drw.c: add alpha param to drw_clr_create
  sed -i 's/^drw_clr_create(Drw \*drw, Clr \*dest, const char \*clrname)$/drw_clr_create(Drw *drw, Clr *dest, const char *clrname, unsigned int alpha)/' "${dir}/drw.c"
  # Only fix the XftColorAllocName call (not XftColorFree)
  sed -i '/XftColorAllocName/{
    s/DefaultVisual(drw->dpy, drw->screen),/drw->visual, drw->cmap,/
    n
    /DefaultColormap/d
  }' "${dir}/drw.c"
  sed -i "/die(\"error, cannot allocate color/a\\	dest->pixel = (dest->pixel \& 0x00ffffffU) | (alpha << 24);" "${dir}/drw.c"

  # drw.c: fix drw_clr_free to use alpha-aware visual/cmap
  sed -i '/XftColorFree/{
    s/DefaultVisual(drw->dpy, drw->screen),$/drw->visual, drw->cmap, c);/
    n
    /DefaultColormap/d
  }' "${dir}/drw.c"

  # drw.c: add alpha param to drw_scm_create
  sed -i 's/^drw_scm_create(Drw \*drw, const char \*clrnames\[\], size_t clrcount)$/drw_scm_create(Drw *drw, const char *clrnames[], const unsigned int clralphas[], size_t clrcount)/' "${dir}/drw.c"
  sed -i 's/drw_clr_create(drw, \&ret\[i\], clrnames\[i\]);/drw_clr_create(drw, \&ret[i], clrnames[i], clralphas[i]);/' "${dir}/drw.c"

  # dwm.c: fix status2d drawstatusbar calls to include alpha parameter
  sed -i 's/drw_clr_create(drw, &drw->scheme\[ColFg\], buf)/drw_clr_create(drw, \&drw->scheme[ColFg], buf, 0xffU)/' "${dir}/dwm.c"
  sed -i 's/drw_clr_create(drw, &drw->scheme\[ColBg\], buf)/drw_clr_create(drw, \&drw->scheme[ColBg], buf, 0xffU)/' "${dir}/dwm.c"

  # dwm.c: fix updatebars for alpha (barpadding-aware version)
  sed -i 's/\.background_pixmap = ParentRelative,/.background_pixel = 0,\n\t\t.border_pixel = 0,\n\t\t.colormap = cmap,/' "${dir}/dwm.c"
  sed -i 's/CWOverrideRedirect|CWBackPixmap|CWEventMask/CWOverrideRedirect|CWBackPixel|CWBorderPixel|CWColormap|CWEventMask/' "${dir}/dwm.c"
  sed -i '/XCreateWindow.*barwin.*DefaultDepth/s/DefaultDepth(dpy, screen)/depth/' "${dir}/dwm.c"
  sed -i '/XCreateWindow.*barwin/s/CopyFromParent, DefaultVisual(dpy, screen)/InputOutput, visual/' "${dir}/dwm.c"

  cp "${ROOT}/suckless/dwm/config.h" "${dir}/config.h"
}

prepare_dmenu() {
  local dir="${SRC_ROOT}/dmenu"
  checkout_latest "${dir}"
  cp "${ROOT}/suckless/dmenu/config.h" "${dir}/config.h"
}

prepare_st() {
  local dir="${SRC_ROOT}/st"
  checkout_latest "${dir}"
  if [ -f "${ROOT}/suckless/st/config.h" ]; then
    cp "${ROOT}/suckless/st/config.h" "${dir}/config.h"
  elif [ -f "${dir}/config.def.h" ]; then
    cp "${dir}/config.def.h" "${dir}/config.h"
  fi
}

prepare_dwmblocks() {
  local dir="${SRC_ROOT}/dwmblocks"
  checkout_latest "${dir}"
  if ! patch -d "${dir}" -p1 < "${PATCH_ROOT_DWMBLOCKS}/dwmblocks-statuscmd-20210402-96cbb45.diff"; then
    echo "warn: dwmblocks statuscmd patch had known partial rejects (continuing with compat patch)" >&2
  fi
  patch -d "${dir}" -p1 < "${PATCH_ROOT_DWMBLOCKS}/dwmblocks-statuscmd-compat.diff"
  cp "${ROOT}/suckless/dwmblocks/blocks.h" "${dir}/blocks.h"
}

build_and_install() {
  local dir="$1"
  (
    cd "${dir}"
    make clean
    make
    if [ -n "${SUDO_PASSWORD:-}" ]; then
      printf '%s\n' "${SUDO_PASSWORD}" | sudo -S make clean install
    else
      sudo make clean install
    fi
  )
}

ensure_sources
bash "${ROOT}/scripts/backup-suckless.sh"

echo "[1/4] Preparing dwm (patch + config)..."
prepare_dwm
echo "[2/4] Preparing dmenu/st/dwmblocks configs..."
prepare_dmenu
prepare_st
prepare_dwmblocks

echo "[3/4] Building and installing from source..."
build_and_install "${SRC_ROOT}/dwm"
build_and_install "${SRC_ROOT}/dmenu"
build_and_install "${SRC_ROOT}/st"
build_and_install "${SRC_ROOT}/dwmblocks"

echo "[4/4] Done."
echo "Installed: dwm, dmenu, st, dwmblocks (from source)"
