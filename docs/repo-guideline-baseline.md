# Repo Guideline Baseline

This document locks the style baseline for `/home/dev/dotfiles` using historical repos as guidance.

## Policy

- Scope: all repos under `/home/dev/repos`.
- Priority order:
  1. `/home/dev/repos/suckless-dots`
  2. `/home/dev/repos/ArchVoiddwm`
  3. `/home/dev/repos/.dotsarch`
  4. `/home/dev/repos/claud`
  5. `/home/dev/repos/guix-rice`
- Conflict policy: balanced blend (keep your old workflow defaults, adopt modern safety/perf improvements when low risk).

## Locked Defaults

| Area | Old repo reference | Locked default |
| --- | --- | --- |
| Theme | `/home/dev/repos/suckless-dots/Xresources/.Xresources` | Gruvbox dark hard/medium with vibrant accent |
| Fonts | `/home/dev/repos/suckless-dots/suckless/dwm/config.h` | Terminus for terminal/UI bars, Nerd Symbols fallback |
| dwm model | `/home/dev/repos/suckless-dots/suckless/dwm/config.h` | Super key workflow, 9 tags, tile/float/monocle |
| dwm patches | `/home/dev/repos/suckless-dots/suckless/build-all.sh` | vanitygaps, pertag, attachbelow, autostart, swallow, systray, statuscmd, hide_vacant_tags, restartsig, actualfullscreen, movestack |
| Status bar | `/home/dev/repos/suckless-dots/scripts/statusbar/*` | `dwmblocks` with modular shell scripts |
| X session | `/home/dev/repos/suckless-dots/xinitrc/.xinitrc` | daemon-first startup (`clipmenud`, `dunst`, `emacs --daemon`, `dwmblocks`) |
| Emacs | `/home/dev/repos/suckless-dots/emacs/init.el` | straight + use-package, Evil + Org + modern completion |
| zsh | `/home/dev/repos/suckless-dots/zsh/.zshrc` | manual plugins, vi mode, fast completion cache, fzf + zoxide |
| Void bootstrap | `/home/dev/repos/ArchVoiddwm/VoidLinux.sh` | Void-first package/service bootstrapping, source-first suckless |
| T490 tuning | `/home/dev/repos/suckless-dots/system/modprobe/i915.conf` | conservative i915 power/stability tuning |

## Target File Mapping

Every file below must map to at least one old-repo reference:

| Target in `/home/dev/dotfiles` | Primary source reference(s) |
| --- | --- |
| `suckless/patch-profile.txt` | `/home/dev/repos/suckless-dots/suckless/build-all.sh` |
| `scripts/fetch-suckless-sources.sh` | `/home/dev/repos/suckless-dots/suckless/patches/*` |
| `scripts/build-suckless-from-source.sh` | `/home/dev/repos/suckless-dots/suckless/build-all.sh` |
| `suckless/dwm/config.h` | `/home/dev/repos/suckless-dots/suckless/dwm/config.h` |
| `xinitrc/.xinitrc` | `/home/dev/repos/suckless-dots/xinitrc/.xinitrc`, `/home/dev/repos/ArchVoiddwm/.xinitrc` |
| `Xresources/.Xresources` | `/home/dev/repos/suckless-dots/Xresources/.Xresources`, `/home/dev/repos/ArchVoiddwm/.Xresources` |
| `scripts/bootstrap-void.sh` | `/home/dev/repos/ArchVoiddwm/VoidLinux.sh`, `/home/dev/repos/claud/scripts/optimize-void-t490.sh` |
| `scripts/xlibre-migrate-void.sh` | `/home/dev/repos/suckless-dots/install.sh` (xlibre flow), XLibre official docs |
| `scripts/xlibre-rollback-void.sh` | rollback conventions from package-manager scripts in old repos |
| `scripts/build-emacs-git.sh` | `/home/dev/repos/suckless-dots/emacs/init.el` workflow, GNU Emacs INSTALL |
| `emacs/early-init.el` | `/home/dev/repos/suckless-dots/emacs/early-init.el` |
| `emacs/init.el` | `/home/dev/repos/suckless-dots/emacs/init.el`, `/home/dev/repos/guix-rice/emacs/init.el` |
| `zsh/.zshrc` | `/home/dev/repos/suckless-dots/zsh/.zshrc` |
| `zsh/.zprofile` | `/home/dev/repos/suckless-dots/zsh/.zprofile` |
| `config.org` | `/home/dev/repos/suckless-dots/config.org`, current `/home/dev/dotfiles/config.org` |

## Explicit Non-Adoptions

- Arch `pacman`/AUR-specific install logic is not copied verbatim into Void scripts.
- Unbounded patch growth beyond the locked list is avoided.
- Framework-heavy zsh setups (full Oh-My-Zsh style) are avoided unless required.
