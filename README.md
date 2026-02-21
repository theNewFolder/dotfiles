# dotfiles

Void Linux productivity setup for ThinkPad T490.

## Locked choices

- strict X11 `dwm`
- 5-patch budget (`pertag`, `actualfullscreen`, `autostart`, `restartsig`, `swallow`)
- `dwmblocks` status bar
- `dmenu` only launcher
- `st` primary + `kitty` fallback
- vanilla Emacs (`use-package`, Evil, Org, Consult/Corfu)
- battery-first profile with TLP threshold `75/85`
- Gruvbox Dark Hard with vibrant accents

## Main files

- `config.org` - source of truth
- `scripts/bootstrap-void.sh` - installs packages/services and applies TLP profile
- `scripts/sync-from-home.sh` - backups selected home configs into this repo
- `scripts/powertop-audit.sh` - generates power tuning report + auto-tune dump
- `scripts/fetch-suckless-sources.sh` - syncs source trees and pinned patch files
- `scripts/build-suckless-from-source.sh` - applies patch set and builds/install tools
- `scripts/backup-suckless.sh` - snapshots source/patch/config into compressed archives
- `scripts/install-statusbar.sh` - installs `dwmblocks` scripts to `~/.local/bin/statusbar`

## Usage

```bash
bash scripts/bootstrap-void.sh
emacs --batch -l org config.org -f org-babel-tangle
bash scripts/fetch-suckless-sources.sh
bash scripts/build-suckless-from-source.sh
bash scripts/install-statusbar.sh
bash scripts/backup-suckless.sh
bash scripts/sync-from-home.sh
```
