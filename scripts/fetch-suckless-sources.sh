#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_ROOT="${ROOT}/suckless/src"
PATCH_ROOT="${ROOT}/suckless/patches/dwm"
PATCH_ROOT_DWMBLOCKS="${ROOT}/suckless/patches/dwmblocks"

mkdir -p "${SRC_ROOT}" "${PATCH_ROOT}" "${PATCH_ROOT_DWMBLOCKS}"

sync_repo() {
  local name="$1"
  local repo="$2"
  local dir="${SRC_ROOT}/${name}"
  local branch=""
  local remote_head=""

  if [ -d "${dir}/.git" ]; then
    git -C "${dir}" remote set-url origin "${repo}"
    git -C "${dir}" fetch --tags --prune origin
  else
    git clone "${repo}" "${dir}"
    git -C "${dir}" fetch --tags --prune origin
  fi

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

echo "[1/3] Syncing suckless source repos..."
sync_repo "dwm" "https://git.suckless.org/dwm"
sync_repo "dmenu" "https://git.suckless.org/dmenu"
sync_repo "st" "https://git.suckless.org/st"
sync_repo "dwmblocks" "https://github.com/torrinfail/dwmblocks.git"

echo "[2/3] Downloading pinned dwm patches..."
download_patch() {
  local name="$1"
  local url="$2"
  curl -fsSL "${url}" -o "${PATCH_ROOT}/${name}"
}

download_patch "dwm-pertag_with_sel-20231003-9f88553.diff" \
  "https://dwm.suckless.org/patches/pertag/dwm-pertag_with_sel-20231003-9f88553.diff"
download_patch "dwm-cfacts-vanitygaps-6.4_combo.diff" \
  "https://dwm.suckless.org/patches/vanitygaps/dwm-cfacts-vanitygaps-6.4_combo.diff"
download_patch "dwm-hide_vacant_tags-6.4.diff" \
  "https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.4.diff"
download_patch "dwm-actualfullscreen-20211013-cb3f58a.diff" \
  "https://dwm.suckless.org/patches/actualfullscreen/dwm-actualfullscreen-20211013-cb3f58a.diff"
download_patch "dwm-autostart-20210120-cb3f58a.diff" \
  "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff"
download_patch "dwm-movestack-20211115-a786211.diff" \
  "https://dwm.suckless.org/patches/movestack/dwm-movestack-20211115-a786211.diff"
download_patch "dwm-barpadding-6.6.diff" \
  "https://dwm.suckless.org/patches/barpadding/dwm-barpadding-6.6.diff"
download_patch "dwm-statuscmd-20260124-a9aa0d8.diff" \
  "https://dwm.suckless.org/patches/statuscmd/dwm-statuscmd-20260124-a9aa0d8.diff"

download_dwmblocks_patch() {
  local name="$1"
  local url="$2"
  curl -fsSL "${url}" -o "${PATCH_ROOT_DWMBLOCKS}/${name}"
}

download_dwmblocks_patch "dwmblocks-statuscmd-20210402-96cbb45.diff" \
  "https://dwm.suckless.org/patches/statuscmd/dwmblocks-statuscmd-20210402-96cbb45.diff"

echo "[3/3] Writing source metadata..."
dwm_commit="$(git -C "${SRC_ROOT}/dwm" rev-parse --short=12 HEAD)"
dmenu_commit="$(git -C "${SRC_ROOT}/dmenu" rev-parse --short=12 HEAD)"
st_commit="$(git -C "${SRC_ROOT}/st" rev-parse --short=12 HEAD)"
dwmblocks_commit="$(git -C "${SRC_ROOT}/dwmblocks" rev-parse --short=12 HEAD)"
generated_at="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

cat > "${ROOT}/suckless/source-lock.txt" <<EOF
dwm repo: https://git.suckless.org/dwm
dwm ref: rolling (origin/HEAD)
dwm commit: ${dwm_commit}
dmenu repo: https://git.suckless.org/dmenu
dmenu ref: rolling (origin/HEAD)
dmenu commit: ${dmenu_commit}
st repo: https://git.suckless.org/st
st ref: rolling (origin/HEAD)
st commit: ${st_commit}
dwmblocks repo: https://github.com/torrinfail/dwmblocks.git
dwmblocks ref: rolling (origin/HEAD)
dwmblocks commit: ${dwmblocks_commit}
patch set: cfacts+vanitygaps, pertag_with_sel, autostart, hide_vacant_tags, actualfullscreen, movestack, barpadding, statuscmd
generated at: ${generated_at}
EOF

echo "Done: sources and patches synced under ${ROOT}/suckless"
