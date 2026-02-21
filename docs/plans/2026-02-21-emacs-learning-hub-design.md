# Emacs Learning Hub & Full System Optimization Design

**Date**: 2026-02-21
**Author**: Omran Al Teneiji (theNewFolder)
**System**: Void Linux, ThinkPad T490, dwm + suckless stack

## Overview

Transform the current minimal dotfiles into a fully integrated Emacs-centric learning
and productivity hub. 7 implementation layers, built in dependency order.

## Decisions Summary

| Decision | Choice |
|----------|--------|
| PKM structure | Single ~/org: GTD at root + roam/ for knowledge + learning/ for notebooks |
| Learning method | Literate notebooks + Zettelkasten + Project-based (all three combined) |
| Babel languages | Bash, Elisp, Python, C |
| dwm integration | Org-capture keybind, agenda keybind, org-protocol, dmenu-emacs buffers |
| AI in Emacs | gptel (Claude + Gemini cloud), no local LLM |
| Extra packages | magit, git-timemachine, embark, wgrep, elfeed, elfeed-org, eglot, vterm |
| Task management | Full GTD without pomodoro. States: TODO NEXT DOING BLOCKED | DONE DROPPED |
| Literate config | Single config.org for everything including Emacs |
| System optimizations | ALL: kernel params, i915, EarlyOOM, irqbalance, PSD, undervolt -80mV, TLP, powertop |
| dwm patches | scratchpad (kitty 100x30) + swallow (all GUI) + xresources |
| dmenu scripts | mount, emoji, pass, shutdown, websearch, emacs-buffers, bookmarks, calc |
| Shell | fzf-tab, fast-syntax-highlighting, zsh-completions, starship, atuin, direnv, bookmarks |
| File manager | lf with full previews (bat, chafa, pdftotext, atool) |
| Dotfiles mgmt | GNU Stow |
| Build philosophy | Always from source: suckless tools + Emacs (native-comp) |
| Font | Terminus Nerd Font everywhere |
| Compositor | picom-ftlabs fork, fade-only animations |
| Eye candy | Nerd Font icons in dwmblocks, gruvbox consistency pass, bar padding |
| XLibre | Install via xlibre-void repo |
| RSS | Emacs ecosystem: Planet Emacslife, Protesilaos, System Crafters, Irreal, Sacha Chua |
| Note templates | 4 types: default, snippet, concept, tutorial |
| Notebook layout | Progressive chapters with exercises |
| Bookmarks | Pre-populate + auto-learn from zoxide |

---

## Layer 1: Foundation

### 1.1 ~/org Directory Structure

```
~/org/
  inbox.org           # GTD capture inbox (process daily)
  todo.org            # Active tasks with NEXT actions
  projects.org        # Project trees
  someday.org         # Someday/maybe
  habits.org          # Recurring habits
  journal.org         # Datetree journal
  bookmarks.org       # Captured URLs
  elfeed.org          # RSS feed definitions (Emacs ecosystem)
  learning/           # Literate notebooks (executable, long-form)
    linux.org         # Linux/sysadmin notebook
    bash.org          # Shell scripting notebook
    emacs.org         # Emacs learning notebook
    lisp.org          # Elisp/Scheme notebook
    ai.org            # AI/LLM notebook
    c.org             # C programming notebook
  roam/               # Atomic zettelkasten notes (org-roam)
    journal/          # org-roam dailies
  archive/            # Archived completed items
```

Each learning notebook follows progressive chapter structure:
```org
* 1. Topic Name
** Concepts
** Code Examples (executable babel blocks)
** Exercises (TODO items)
** Notes (links to roam nodes)
```

### 1.2 GNU Stow Migration

Restructure ~/dotfiles/ for stow:
```
~/dotfiles/
  config.org              # Literate source (tangles everything)
  stow/
    zsh/.zshrc
    zsh/.zprofile
    emacs/.emacs.d/early-init.el
    emacs/.emacs.d/init.el
    xinitrc/.xinitrc
    xresources/.Xresources
    fontconfig/.config/fontconfig/fonts.conf
    picom/.config/picom/picom.conf
    lf/.config/lf/lfrc
    lf/.config/lf/preview
    starship/.config/starship.toml
    atuin/.config/atuin/config.toml
    dunst/.config/dunst/dunstrc
  suckless/               # Not stowed (built from source)
  scripts/                # Not stowed (installed to ~/.local/bin)
```

Deploy: `cd ~/dotfiles/stow && stow -t ~ zsh emacs xinitrc xresources fontconfig picom lf starship atuin dunst`

### 1.3 Terminus Nerd Font

Install TerminessNerdFont from nerd-fonts releases:
```bash
mkdir -p ~/.local/share/fonts
# Download and extract TerminessNerdFont
fc-cache -fv
```

Configure in: dwm config.h, st config.h, dmenu config.h, kitty.conf,
Emacs init.el, Xresources, starship.toml, lf.

### 1.4 Migrate PKM Content

Merge content from three repos into ~/org/:
- ~/repos/org-pkm/ -> merge GTD files into ~/org/
- ~/repos/pkm/ -> merge gtd/ files into ~/org/
- ~/repos/ai-knowledge/ -> merge learning/ into ~/org/learning/ and roam/

---

## Layer 2: Emacs Core (config.org)

Convert init.el to literate config.org with these sections:

### 2.1 Early Init
Tangles to ~/.emacs.d/early-init.el. GC threshold, frame defaults,
native-comp silence, gruvbox background color.

### 2.2 Bootstrap
straight.el + use-package. Same as current init.el.

### 2.3 Performance
gcmh, read-process-output-max 4MB.

### 2.4 Core Defaults
UI cleanup, scrolling, backups disabled, Terminus Nerd Font 14pt,
relative line numbers, auto-revert.

### 2.5 Theme
gruvbox-dark-hard.

### 2.6 Evil
evil + evil-collection. C-u scroll, split behavior.

### 2.7 Completion Stack
vertico, orderless, marginalia, consult, corfu, embark + wgrep.

### 2.8 Which-Key
0.3s delay.

### 2.9 Org-Mode Core
- org-directory: ~/org
- Babel languages: shell, emacs-lisp, python, C
- Structure templates: <el, <sh, <py, <c TAB
- Appearance: org-modern, hide-emphasis-markers, indentation
- org-confirm-babel-evaluate nil

### 2.10 GTD System
TODO keywords: TODO(t) NEXT(n) DOING(d) BLOCKED(b@/!) | DONE(!) DROPPED(x@/!)

Capture templates:
- i: Inbox (quick capture)
- t: Task with context link
- n: Note
- j: Journal (datetree)
- b: Bookmark/URL
- H: Habit

Refile targets: projects.org, someday.org, archive/

Custom agenda views:
- d: Dashboard (today + NEXT + DOING + BLOCKED + inbox)
- W: Weekly Review (7-day + stuck projects + BLOCKED + all projects)
- Context: @home, @work, @errands

org-super-agenda groups: Overdue, Due Today, DOING, NEXT, Habits, etc.

org-habit configuration for streak tracking.

org-clock for time tracking (no pomodoro).

### 2.11 Org-Roam (Zettelkasten)
Directory: ~/org/roam/
Database: sqlite-builtin
Dailies: ~/org/roam/journal/

Capture templates:
- d: Default/permanent note
- s: Code snippet (Source, Code block, Explanation, Tags)
- c: Concept note (Definition, Related concepts, Links)
- w: Tutorial walkthrough (Prerequisites, Steps, Troubleshooting)
- l: Literature note (Author, Title, URL, Summary, Key Ideas)
- f: Fleeting note (quick capture)

Node display: title + tags.

### 2.12 Org-Protocol
Browser capture from Firefox via bookmarklet.
Template "W" for web captures.

### 2.13 Auto-Tangle
Tangle config.org on save. Watches for the specific file path.

---

## Layer 3: Emacs Integrations

### 3.1 Git
magit + git-timemachine.

### 3.2 RSS
elfeed + elfeed-org. Feeds in ~/org/elfeed.org:
- Planet Emacslife
- Protesilaos codelog
- System Crafters
- Irreal
- Sacha Chua weekly

### 3.3 AI
gptel with Claude (Anthropic API) + Gemini (Google API) backends.
Keybindings: C-c g for gptel-send, C-c G for gptel menu.
API keys stored in ~/.authinfo.gpg or env vars.

### 3.4 LSP
eglot (built-in Emacs 29+) for:
- bash-language-server
- pyright (Python)
- clangd (C)
- Auto-start on prog-mode hooks

### 3.5 Terminal
vterm with evil-collection bindings.
Toggle keybinding in Emacs.

### 3.6 File Management
dired with basic configuration (human-readable sizes, auto-revert).

---

## Layer 4: dwm Integration

### 4.1 New Keybindings (config.h)

| Keybind | Command |
|---------|---------|
| Super+c | emacsclient -c -e "(org-capture)" |
| Super+a | emacsclient -c -e "(org-agenda-list)" |
| Super+n | emacsclient -c -e "(org-roam-node-find)" |

### 4.2 org-protocol

Desktop file for org-protocol handler.
Firefox bookmarklet for web capture.
xdg-open integration.

### 4.3 dmenu-emacs

Script to list Emacs buffers via emacsclient, display in dmenu,
switch to selected buffer. Filter by file/magit/hidden.

---

## Layer 5: dwm Patches (Rebuild from Source)

### 5.1 New Patches (3 additions to existing 8 = 11 total)

1. scratchpad - Toggle hidden kitty terminal (100x30, centered) with Super+grave
2. swallow - All GUI apps spawned from terminal replace the terminal window
3. xresources - Read colors/fonts from .Xresources at startup

### 5.2 Build Process

```bash
cd ~/dotfiles/suckless/src/dwm
# Apply existing 8 patches
# Apply 3 new patches (test for conflicts)
# Copy config.h
sudo make clean install
```

### 5.3 Nerd Font Icons in dwmblocks

Update all sb-* scripts to use Nerd Font icon prefixes:
- sb-volume:
- sb-cpu:
- sb-memory:
- sb-battery:  (dynamic based on level)
- sb-network:  /  (wifi/ethernet)
- sb-temp:
- sb-date:

### 5.4 Gruvbox Consistency Pass

Verify all tools use exact Gruvbox Dark Hard palette:
- #282828 bg, #ebdbb2 fg, #fe8019 orange, #b8bb26 green
- #fb4934 red, #83a598 blue, #d3869b purple, #8ec07c aqua
- #fabd2f yellow

Apply to: picom shadows, dmenu, dunst, lf, st, kitty.

---

## Layer 6: Shell & Tools

### 6.1 Zsh Enhancements

New plugins:
- fzf-tab (replace default completion with fzf)
- fast-syntax-highlighting (faster than zsh-syntax-highlighting)
- zsh-completions (400+ extra completions)

Replace zsh-syntax-highlighting with fast-syntax-highlighting.

fzf-tab preview config:
- Directories: eza preview
- Files: bat preview
- Gruvbox colors

Compile .zshrc to .zshrc.zwc for faster loading.

### 6.2 Starship Prompt

~/.config/starship.toml with gruvbox-minimal theme:
- Directory (bold yellow, truncated to 3)
- Git branch (bold purple)
- Git status
- Minimal character (green/red)

### 6.3 Atuin (Shell History)

Replace Ctrl-R with atuin:
- SQLite-backed
- Fuzzy search
- Context-aware (directory, exit code)
- Gruvbox styled

### 6.4 Direnv

Per-directory .envrc loading.
Emacs envrc package for editor integration.

### 6.5 Bookmark System

~/.config/shell/bm-dirs:
```
d   ~/Documents
D   ~/Downloads
o   ~/org
or  ~/org/roam
ol  ~/org/learning
r   ~/repos
df  ~/dotfiles
s   ~/dotfiles/suckless
```

~/.config/shell/bm-files:
```
cf  ~/dotfiles/config.org
zr  ~/dotfiles/zsh/.zshrc
ei  ~/dotfiles/emacs/.emacs.d/init.el
dw  ~/dotfiles/suckless/dwm/config.h
xi  ~/dotfiles/xinitrc/.xinitrc
```

`shortcuts` script generates shell aliases from these files.
Integrate with zoxide frecency for auto-learning.

### 6.6 lf File Manager

Replace ranger with lf (Go, faster).
Config: ~/.config/lf/lfrc
Preview script: bat (text), chafa (images), pdftotext (PDF), atool (archives).
Gruvbox colors. Icons via Nerd Font.
Opener: xdg-open fallback.

### 6.7 dmenu Scripts (8 total)

All installed to ~/.local/bin/:
1. dmenu-mount - mount/unmount USB, Android, ISO
2. dmenu-emoji - emoji picker -> clipboard
3. dmenu-pass - password manager (pass + dmenu)
4. dmenu-power - shutdown/reboot/lock/suspend
5. dmenu-websearch - query -> Firefox
6. dmenu-emacs - switch/close Emacs buffers
7. dmenu-bookmarks - browse Firefox bookmarks
8. dmenu-calc - calculator -> clipboard

---

## Layer 7: System Tuning

### 7.1 Kernel Boot Parameters

Add to GRUB cmdline:
```
loglevel=3 console=tty2 nowatchdog mitigations=off
```

### 7.2 fstab

Add `noatime` to all ext4/btrfs mount options.

### 7.3 Intel i915

/etc/modprobe.d/i915.conf:
```
options i915 enable_guc=2 enable_dc=4 enable_fbc=1
```

### 7.4 New Services (xbps + runit)

Install and enable:
- earlyoom (kill runaway processes before OOM)
- irqbalance (distribute hardware interrupts)
- profile-sync-daemon (browser profiles in RAM)

### 7.5 TLP Advanced Profile

/etc/tlp.conf updates:
- DISK_APM_LEVEL_ON_BAT="128"
- SOUND_POWER_SAVE_ON_BAT=1
- USB_AUTOSUSPEND=1
- TPACPI_ENABLE=1
- TPSMAPI_ENABLE=1
- Keep existing 75/85 battery thresholds

### 7.6 Intel Undervolt

Install intel-undervolt.
Initial config: -80mV on CPU and cache.
Create runit service for persistence.
Stress test with: `stress-ng --cpu 4 --timeout 300`

### 7.7 Powertop Auto-Tune

Create runit service:
```
/etc/sv/powertop-autotune/run:
#!/bin/sh
exec powertop --auto-tune 2>&1
```

### 7.8 picom-ftlabs

Build picom-ftlabs from source (replaces stock picom).
Config: fade-only animations, keep existing blur/shadow/corners/opacity.
Animation settings: fade-in-step=0.03, fade-out-step=0.03.

### 7.9 XLibre

Add xlibre-void repository.
Install xlibre-minimal.
Update xlibre-migrate-void.sh and xlibre-rollback-void.sh scripts.
Test X session startup.

---

## Sources & References

- [Suckless Philosophy](https://suckless.org/philosophy/)
- [Suckless Recommended Software](https://suckless.org/rocks/)
- [Luke Smith LARBS / Voidrice](https://github.com/LukeSmithxyz/voidrice)
- [LARBS Guide](https://larbs.xyz/)
- [System Crafters Guides](https://systemcrafters.net/guides/)
- [David Wilson Emacs Config](https://config.daviwil.com/emacs)
- [System Crafters Crafter Configs](https://github.com/SystemCrafters/crafter-configs)
- [dmenu-suite](https://github.com/DAFF0D11/dmenu-suite)
- [Void Linux Optimizations Gist](https://gist.github.com/themagicalmammal/e443d3c5440d566f8206e5b957ab1493)
- [Void + Suckless Combo](http://krishxmatta.dev/void-linux-and-suckless-software.html)
- [mad-ara/void-rice](https://github.com/mad-ara/void-rice)
- [dwm Patches](https://dwm.suckless.org/patches/)
- [bakkeby/patches](https://github.com/bakkeby/patches)
- [picom-ftlabs](https://github.com/HcGys/FT-Labs-picom)
- [fzf-tab](https://github.com/Aloxaf/fzf-tab)
- [XLibre for Void](https://github.com/xlibre-void/xlibre)
- [XLibre Xserver](https://github.com/X11Libre/xserver)
- [Jethro Kuan Org-Roam Guide](https://jethrokuan.github.io/org-roam-guide/)
- [Org-Roam Manual](https://www.orgroam.com/manual.html)
- [TLP ThinkPad Guide](https://hamradio.my/2025/07/tlp-thinkpad-ultimate-linux-battery-thermal-management-for-old-laptops/)
- [Alderson/dotfiles (Codeberg)](https://codeberg.org/alderson/dotfiles/)
- [SnowCode/rice (Codeberg)](https://codeberg.org/SnowCode/rice)
- [Nerd Fonts](https://www.nerdfonts.com)
