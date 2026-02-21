# Desktop Rice Design - ThinkPad T490 Void Linux

**Date**: 2026-02-21
**Machine**: ThinkPad T490 (i5-8365U, 16GB, Intel UHD 620)
**OS**: Void Linux glibc, XLibre 25.1.2, dwm

---

## 1. Theme: Gruvbox Baby Ultra-Dark Vibrant

Background `#0d0e0f` (near-black) with original Gruvbox bright accents for maximum contrast.

### Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| bg_darkest | `#0d0e0f` | Primary bg (bar, terminals, dmenu) |
| bg_dark | `#141617` | Notification bg, elevated surfaces |
| bg_medium | `#1d2021` | Selected items, hover |
| bg_light | `#282828` | Inactive elements |
| bg_lighter | `#3c3836` | Active borders |
| fg | `#ebdbb2` | Primary text |
| fg_dim | `#a89984` | Secondary/inactive text |
| fg_bright | `#fbf1c7` | Emphasized text |
| red | `#fb4934` | CPU, errors, critical |
| orange | `#fe8019` | RAM, accent, focused border |
| yellow | `#fabd2f` | Clock, brightness, warnings |
| green | `#b8bb26` | Battery, music, success |
| blue | `#83a598` | WiFi, volume info |
| aqua | `#8ec07c` | Volume, updates |
| purple | `#d3869b` | Emacs, screenshots |
| gray | `#928374` | Comments, separators |

### Apply Everywhere

- dwm config.h (bar, borders, tags)
- st config.h (terminal colors)
- dmenu config.h (menu colors)
- kitty.conf (terminal colors)
- qutebrowser config.py (full UI theme)
- dunst dunstrc (notification colors)
- btop (Gruvbox theme)
- newsboat, ncmpcpp, yazi, zathura (Gruvbox configs)
- fzf, bat (already themed, update bg)
- Xresources (DPI + colors)

---

## 2. Font: DankMono Nerd Font Everywhere

- **Size**: 22px for suckless tools (dwm, st, dmenu)
- **Size**: 16pt for kitty
- **Size**: 12pt for qutebrowser
- **Size**: 11pt for dunst
- **Rendering**: Optimized for 14" 1080p LCD (hintslight, RGB subpixel, stem darkening)
- **Antialiasing**: ON (required for vector font)
- **Autohint**: OFF
- **Stem darkening**: ON (fixes thin text on Gruvbox dark bg)

### fontconfig (fonts.conf)

```xml
hintstyle: hintslight (vertical-only grid-fitting, preserves DankMono proportions)
rgba: rgb (exploits LCD subpixel layout for 3x horizontal resolution)
lcdfilter: lcddefault (eliminates color fringing)
antialias: true
hinting: true
autohint: false
embeddedbitmap: false
```

### FreeType2 (/etc/profile.d/freetype2.sh)

```bash
FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"
```

### Xresources

```
Xft.dpi: 96
Xft.antialias: true
Xft.hinting: true
Xft.rgba: rgb
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
```

---

## 3. dwm Modifications

### New Patches (add to existing 8)

1. **status2d** - Colored text/icons in status bar
2. **alpha** - Transparent bar with compositor support

### Tag Icons (replace numbers 1-9)

```
" " " 󰈹" " " " " " 󰕼" " 󰍩" " 󰎆" " " " 󰇮"
```

### Color Scheme

```c
SchemeNorm: fg=#a89984, bg=#0d0e0f, border=#282828
SchemeSel:  fg=#ebdbb2, bg=#0d0e0f, border=#fe8019
```

### Bar Alpha

```c
baralpha = 0xe0;  /* ~88% opaque */
borderalpha = OPAQUE;
```

---

## 4. dwmblocks - 6 Essential Blocks (Rainbow)

| # | Block | Icon | Color | Script | Interval | Signal |
|---|-------|------|-------|--------|----------|--------|
| 1 | CPU | `` | `#fb4934` | sb-cpu | 5s | 0 |
| 2 | RAM | `󰍛` | `#fe8019` | sb-memory | 10s | 0 |
| 3 | WiFi | `󰖩` | `#83a598` | sb-internet | 5s | 4 |
| 4 | Volume | `󰕾` | `#8ec07c` | sb-volume | 0 | 10 |
| 5 | Battery | `󰁹` | `#b8bb26` | sb-battery | 30s | 3 |
| 6 | Clock | `󰥔` | `#fabd2f` | sb-clock | 60s | 1 |

Scripts output status2d color codes: `^c#fb4934^ 42%^d^`

---

## 5. Picom - Glassmorphism + Native Animations

**Use mainline picom v12+** (NOT a fork). Native animation support.

### Key Settings

- **Backend**: GLX
- **VSync**: OFF (XLibre TearFree handles it)
- **Blur**: dual_kawase strength 5
- **Corners**: 14px (exclude bar, dmenu)
- **Shadows**: 8px radius, 0.6 opacity
- **Animations**: fly-in/out for open/close, slide for show/hide (0.15-0.18s)

### Transparency Rules

| Window | Focused | Unfocused |
|--------|---------|-----------|
| kitty | 85% | 75% |
| st | 85% | 75% |
| dmenu | 85% | - |
| dwm bar | 88% | - |
| Firefox/Emacs | 100% | 95% |
| mpv | 100% | 100% |

---

## 6. XLibre Optimizations

### /etc/X11/xorg.conf.d/20-intel-modesetting.conf

```
Section "Device"
    Identifier "Intel Graphics"
    Driver "modesetting"
    Option "AccelMethod" "glamor"
    Option "DRI" "3"
    Option "TearFree" "true"
    Option "TripleBuffer" "true"
    Option "PageFlip" "true"
EndSection
```

### /etc/modprobe.d/i915.conf

```
options i915 enable_fbc=1 enable_guc=2 enable_dc=2 enable_psr=1 fastboot=1
```

---

## 7. Shell & Defaults

- `chsh -s /usr/bin/zsh` (make zsh default)
- `.zprofile` already auto-starts X on tty1/tty2
- `TERMINAL=kitty` in .zshrc
- `BROWSER=qutebrowser` in .zshrc

---

## 8. Tool Installations

```bash
xbps-install -S nsxiv zathura zathura-pdf-mupdf maim slop yazi pass \
  newsboat xdotool xclip entr abduco dvtm yt-dlp mpd ncmpcpp mpc \
  qutebrowser kitty btop papirus-icon-theme
```

---

## 9. Qutebrowser - Full Gruvbox Rice

- Gruvbox Dark theme (gruvbox.py from The-Compiler)
- Background: `#0d0e0f`
- DankMono Nerd Font 12pt
- Custom HTML startpage with clock + bookmark grid
- Chromium dark mode for websites
- Ad blocking: uBlock lists + hosts blocking
- Privacy: no WebRTC, no canvas, no 3rd-party cookies
- dmenu integration, mpv launch, pass password fill
- Set as default: xdg-settings + BROWSER env

---

## 10. Dunst - Glassmorphism Notifications

- Corner radius: 12px (dunst native, NOT picom)
- Frame: 2px bright orange `#fe8019`
- Semi-transparent via picom blur
- Gap: 6px between notifications
- DankMono Nerd Font 11
- Papirus-Dark icons
- Color-coded rules: blue=volume, yellow=brightness, green=music, red=critical
- Progress bars for volume/brightness with stack-tag dedup
- Picom exclusion: `rounded-corners-exclude = ["class_g = 'Dunst'"]`

---

## 11. btop - Gruvbox + Full Layout

- Gruvbox Dark theme
- All 4 panels: CPU graph + per-core, Memory + disk, Network, Processes
- Custom layout config

---

## 12. Terminal App Theming (Gruvbox Dark)

- newsboat: Gruvbox colors in config
- ncmpcpp: Gruvbox color scheme
- yazi: BLK color env vars
- zathura: Gruvbox recolor settings
- fzf: Update bg to #0d0e0f
- bat: Already themed (Gruvbox)

---

## 13. Emacs Dashboard

- emacs-dashboard package
- Sections: Recent files, org-agenda TODOs, bookmarks, keybinding cheatsheet
- Gruvbox themed

---

## 14. Wallpapers

- Download 20-30 from gruvbox-wallpapers.pages.dev
- Random rotation via feh in xinitrc
- 1920x1080+ resolution only
