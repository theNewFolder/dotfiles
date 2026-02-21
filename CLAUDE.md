# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Void Linux dotfiles for ThinkPad T490. Source-built suckless WM stack (dwm, dmenu, st, dwmblocks) with literate config via Org-mode, GNU Stow for symlinking, and runit user services.

## Bootstrap Pipeline

```bash
bash scripts/bootstrap-void.sh                      # xbps packages + runit services + TLP
emacs --batch -l org config.org -f org-babel-tangle  # tangle config.org → xinitrc, Xresources, emacs configs
bash scripts/fetch-suckless-sources.sh               # clone suckless repos + download patches
bash scripts/build-suckless-from-source.sh           # patch → copy config.h → make install (dwm/dmenu/st/dwmblocks)
bash scripts/install-statusbar.sh                    # cp scripts/statusbar/sb-* → ~/.local/bin/statusbar
```

## Building Suckless Tools

After editing a config.h or patch:
```bash
bash scripts/build-suckless-from-source.sh   # resets source, re-applies patches, copies config.h, builds all
```

Individual rebuild (rare, prefer the full script):
```bash
cd suckless/src/dwm && sudo make clean install
```

Patches are applied in order from `suckless/patches/dwm/`. Compat patches (e.g., `dwm-statuscmd-barpadding-compat.diff`) are applied after the main set. The build script auto-runs `backup-suckless.sh` before building.

## Architecture

### Source of Truth

`config.org` is the literate config — it tangles into:
- `xinitrc/.xinitrc`
- `Xresources/.Xresources`
- `emacs/early-init.el`, `emacs/init.el`

Edit `config.org`, then re-tangle. Don't edit tangled outputs directly.

### Key Config Files (edited directly, not tangled)

- `suckless/dwm/config.h` — dwm keybindings, tags, layouts, colors
- `suckless/dwmblocks/blocks.h` — statusbar block definitions (command, interval, signal)
- `suckless/dmenu/config.h` — dmenu appearance
- `suckless/st/config.h` — st terminal config (if present)
- `stow/*/` — app configs symlinked via GNU Stow (kitty, picom, dunst, etc.)

### Statusbar

`scripts/statusbar/sb-*` are modular shell scripts called by dwmblocks. Each block has a signal number defined in `blocks.h` — refresh a block with `kill -$((sig+34)) $(pidof dwmblocks)`. Scripts use `status2d` color markup (`^c#HEX^text^d^`) and support click actions via `$BUTTON` (1=left, 3=right, 4=scrollup, 5=scrolldown).

### Services

Runit user services in `runit/` (emacs daemon, ssh-agent, syncthing). Started via `runsvdir` from xinitrc with `SVDIR=$HOME/.local/sv`.

## Locked Decisions

These are intentional constraints — do not change without explicit request:

- **WM**: dwm on X11 only (no Wayland)
- **Launcher**: dmenu only (no rofi/bemenu)
- **Theme**: Gruvbox Dark Hard, primary `#0d0e0f`, accent `#fe8019`
- **Fonts**: DankMono Nerd Font (dwm/dmenu/Emacs)
- **Battery**: TLP 75/85 charge thresholds, powersave on battery
- **Emacs**: straight.el + use-package + Evil, no Doom/Spacemacs
- **Shell**: zsh with manual plugins, vi mode, fzf + zoxide
- **Patches**: keep patch set small and intentional

## Audio

Audio uses **PipeWire + WirePlumber** (`wpctl`). Both dwm keybindings and statusbar scripts use `wpctl` for volume control. Statusbar signals dwmblocks on volume change: `kill -44 $(pidof dwmblocks)` (signal 10 + 34).

## dmenu Scripts

Custom dmenu-based utilities in `scripts/`: `sysact` (power menu), `dmenu-power`, `dmenu-websearch`, `dmenu-emoji`, `dmenu-calc`, `dmenu-emacs`. These are bound to keys in dwm/config.h and available on PATH via xinitrc.

## Conventions

- Scripts use `set -euo pipefail` and resolve `$ROOT` relative to script location
- Statusbar scripts are self-contained, print one line to stdout, use `notify-send` for expanded info on click
- Statusbar scripts read sysfs via shell `read` builtin (not `cat`) for battery-first performance
- Suckless source repos live in `suckless/src/` (gitignored submodules), custom configs in `suckless/<tool>/config.h`
- Patch files in `suckless/patches/<tool>/`, ordered by application sequence in the build script
- Stow directories mirror `$HOME` structure (e.g., `stow/kitty/.config/kitty/kitty.conf`)
- `TERMINAL`, `EDITOR`, `BROWSER` environment variables are exported in xinitrc
