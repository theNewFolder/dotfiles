# Desktop Rice Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Transform ThinkPad T490 Void Linux desktop from functional dwm setup to fully-riced Gruvbox Baby ultra-dark glassmorphism environment with DankMono Nerd Font everywhere.

**Architecture:** Modify suckless source configs (config.h), apply 2 new dwm patches (status2d + alpha), rewrite statusbar scripts for colored output, create new app configs (qutebrowser, dunst, btop, kitty), update font rendering system-wide, and install missing productivity tools.

**Tech Stack:** dwm/st/dmenu (C, config.h), picom v12 (conf), zsh, kitty, qutebrowser (Python), dunst (INI), fontconfig (XML), Xresources, GNU Stow

**Design Doc:** `docs/plans/2026-02-21-desktop-rice-design.md`

---

## Phase 1: Foundation (system-level, do first)

### Task 1: Install Missing Packages

**Files:**
- None (system packages)

**Step 1: Install all missing tools**

```bash
sudo xbps-install -Sy kitty qutebrowser nsxiv zathura zathura-pdf-mupdf \
  yazi newsboat slop entr abduco dvtm yt-dlp papirus-icon-theme
```

Already installed: btop, ncmpcpp, maim, pass, xdotool, xclip, mpd, mpc, dunst, picom

**Step 2: Verify installations**

```bash
which kitty qutebrowser nsxiv zathura yazi newsboat slop entr abduco dvtm yt-dlp
```

Expected: All paths print successfully.

**Step 3: Make zsh default shell**

```bash
sudo chsh -s /usr/bin/zsh dev
```

**Step 4: Verify**

```bash
grep dev /etc/passwd | grep zsh
```

Expected: `/usr/bin/zsh` at end of line.

---

### Task 2: XLibre + GPU Optimization

**Files:**
- Modify: `/etc/X11/xorg.conf.d/20-intel-modesetting.conf`
- Modify: `/etc/modprobe.d/i915.conf`
- Modify: `~/dotfiles/xorg/20-intel-modesetting.conf` (repo copy)

**Step 1: Update xorg.conf**

Write to `/etc/X11/xorg.conf.d/20-intel-modesetting.conf`:

```
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "modesetting"
    Option      "AccelMethod"   "glamor"
    Option      "DRI"           "3"
    Option      "TearFree"      "true"
    Option      "TripleBuffer"  "true"
    Option      "PageFlip"      "true"
EndSection

Section "ServerFlags"
    Option      "AutoAddGPU"    "false"
EndSection
```

**Step 2: Update i915 kernel module params**

Write to `/etc/modprobe.d/i915.conf`:

```
options i915 enable_fbc=1 enable_guc=2 enable_dc=2 enable_psr=1 fastboot=1
```

**Step 3: Copy to dotfiles repo**

```bash
cp /etc/X11/xorg.conf.d/20-intel-modesetting.conf ~/dotfiles/xorg/
```

---

### Task 3: Font Rendering - DankMono Optimized for 1080p LCD

**Files:**
- Modify: `~/dotfiles/fontconfig/fonts.conf`
- Modify: `~/dotfiles/Xresources/.Xresources`
- Create: `/etc/profile.d/freetype2.sh`
- Stow target: `~/.config/fontconfig/fonts.conf`
- Stow target: `~/.Xresources`

**Why hintslight+rgb, NOT hintnone+grayscale:** Research confirmed hintnone is only for 4K+ HiDPI. On 14" 1080p, hintslight gives vertical-only grid-fitting (preserves DankMono's proportions while keeping sharp stems). RGB subpixel rendering exploits the LCD's physical subpixel layout for 3x effective horizontal resolution. Stem darkening is critical for Gruvbox's light-on-dark text.

**Step 1: Enable Void Linux fontconfig system presets**

```bash
sudo ln -sf /usr/share/fontconfig/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d/
sudo ln -sf /usr/share/fontconfig/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d/
sudo ln -sf /usr/share/fontconfig/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d/
sudo ln -sf /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo xbps-reconfigure -f fontconfig
```

**Step 2: Create FreeType2 environment config**

Write `/etc/profile.d/freetype2.sh`:

```bash
#!/bin/sh
# TrueType interpreter v40: modern minimal hinting (macOS/DirectWrite-like)
# Stem darkening: fixes thin/faint text on Gruvbox dark backgrounds
export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"
```

```bash
sudo chmod +x /etc/profile.d/freetype2.sh
```

**Step 3: Update fontconfig**

Write `~/dotfiles/fontconfig/fonts.conf`:

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <!-- Optimized rendering for 14" 1080p IPS LCD -->
  <match target="font">
    <edit name="antialias" mode="assign"><bool>true</bool></edit>
    <edit name="hinting" mode="assign"><bool>true</bool></edit>
    <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
    <edit name="rgba" mode="assign"><const>rgb</const></edit>
    <edit name="lcdfilter" mode="assign"><const>lcddefault</const></edit>
    <edit name="autohint" mode="assign"><bool>false</bool></edit>
    <edit name="embeddedbitmap" mode="assign"><bool>false</bool></edit>
  </match>

  <!-- Noto Color Emoji: keep embedded bitmap -->
  <match target="font">
    <test name="family" compare="contains"><string>Emoji</string></test>
    <edit name="embeddedbitmap" mode="assign"><bool>true</bool></edit>
  </match>

  <!-- DankMono as #1 system monospace -->
  <alias binding="same">
    <family>monospace</family>
    <prefer>
      <family>DankMono Nerd Font</family>
      <family>DankMono Nerd Font Mono</family>
      <family>Symbols Nerd Font</family>
      <family>Symbols Nerd Font Mono</family>
      <family>DejaVu Sans Mono</family>
    </prefer>
  </alias>

  <!-- Nerd Font icon fallback chain -->
  <alias>
    <family>DankMono Nerd Font</family>
    <prefer>
      <family>DankMono Nerd Font</family>
      <family>Symbols Nerd Font</family>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>

  <!-- Map common monospace aliases -->
  <alias><family>Courier</family><prefer><family>DankMono Nerd Font</family></prefer></alias>
  <alias><family>Courier New</family><prefer><family>DankMono Nerd Font</family></prefer></alias>
</fontconfig>
```

**Step 4: Update Xresources**

Update the font rendering section in `~/dotfiles/Xresources/.Xresources`:

Replace the `Xft.*` lines with:

```
Xft.dpi:        96
Xft.antialias:  true
Xft.hinting:    true
Xft.rgba:       rgb
Xft.hintstyle:  hintslight
Xft.lcdfilter:  lcddefault
Xft.autohint:   false
```

Also update all color definitions to use `#0d0e0f` as background:

```
*background:    #0d0e0f
*foreground:    #ebdbb2
*cursorColor:   #fe8019
*borderColor:   #282828

! Gruvbox Dark 16 colors
*color0:  #0d0e0f
*color1:  #cc241d
*color2:  #98971a
*color3:  #d79921
*color4:  #458588
*color5:  #b16286
*color6:  #689d6a
*color7:  #a89984
*color8:  #928374
*color9:  #fb4934
*color10: #b8bb26
*color11: #fabd2f
*color12: #83a598
*color13: #d3869b
*color14: #8ec07c
*color15: #ebdbb2
```

**Step 5: Restow fontconfig and xresources**

```bash
cd ~/dotfiles/stow && stow -R fontconfig xresources
xrdb -merge ~/.Xresources
```

**Step 6: Verify font rendering**

```bash
fc-match monospace
fc-match --verbose monospace | grep -E 'antialias|hinting|hintstyle|rgba|lcdfilter'
echo $FREETYPE_PROPERTIES
xrdb -query | grep Xft
```

Expected: `DankMono Nerd Font` (or similar DankMono variant).

---

## Phase 2: Suckless Stack (dwm + dwmblocks + st + dmenu)

### Task 4: Fetch and Apply New dwm Patches (status2d + alpha)

**Files:**
- Modify: `~/dotfiles/suckless/dwm/config.h`
- Modify: `~/dotfiles/scripts/fetch-suckless-sources.sh`
- Modify: `~/dotfiles/scripts/build-suckless-from-source.sh`
- Download: status2d and alpha patches to `~/dotfiles/suckless/patches/`

**Step 1: Download new patches**

```bash
cd ~/dotfiles/suckless/patches
curl -LO "https://dwm.suckless.org/patches/status2d/dwm-status2d-6.3.diff"
curl -LO "https://dwm.suckless.org/patches/alpha/dwm-alpha-20230519-6.4.diff"
curl -LO "https://dwm.suckless.org/patches/alpha/dwm-fixborders-6.2.diff"
```

Note: Patch versions may need adjustment. Check suckless.org for latest compatible versions.

**Step 2: Update fetch-suckless-sources.sh to include new patches**

Add the new patch URLs to the download section.

**Step 3: Update build-suckless-from-source.sh to apply new patches**

Add status2d and alpha to the patch application order (apply AFTER statuscmd since both modify the bar).

**Step 4: Apply patches to dwm source**

```bash
cd ~/dotfiles/suckless/src/dwm
git checkout .
# Apply existing patches first (in order from patch-profile.txt)
# Then apply status2d
patch -p1 < ../../patches/dwm-status2d-6.3.diff
# Then apply alpha + fixborders
patch -p1 < ../../patches/dwm-alpha-20230519-6.4.diff
patch -p1 < ../../patches/dwm-fixborders-6.2.diff
```

If patches conflict, manual resolution needed. The status2d patch modifies `drw.c` and `dwm.c` bar drawing code. Alpha modifies color handling.

---

### Task 5: Update dwm config.h

**Files:**
- Modify: `~/dotfiles/suckless/dwm/config.h`

**Step 1: Update colors to Gruvbox Baby ultra-dark**

Replace color definitions:

```c
/* Gruvbox Baby Ultra-Dark Vibrant */
static const char gruvbg[]       = "#0d0e0f";
static const char gruvbg1[]      = "#141617";
static const char gruvbg2[]      = "#1d2021";
static const char gruvbg3[]      = "#282828";
static const char gruvbg4[]      = "#3c3836";
static const char gruvfg[]       = "#ebdbb2";
static const char gruvfg4[]      = "#a89984";
static const char gruvgray[]     = "#928374";
static const char gruvred[]      = "#cc241d";
static const char gruvred1[]     = "#fb4934";
static const char gruvgreen[]    = "#98971a";
static const char gruvgreen1[]   = "#b8bb26";
static const char gruvyellow[]   = "#d79921";
static const char gruvyellow1[]  = "#fabd2f";
static const char gruvblue[]     = "#458588";
static const char gruvblue1[]    = "#83a598";
static const char gruvpurple[]   = "#b16286";
static const char gruvaqua[]     = "#689d6a";
static const char gruvaqua1[]    = "#8ec07c";
static const char gruvorange[]   = "#d65d0e";
static const char gruvorange1[]  = "#fe8019";
```

**Step 2: Update color scheme arrays**

```c
static const unsigned int baralpha    = 0xe0; /* ~88% opaque */
static const unsigned int borderalpha = OPAQUE;

static const char *colors[][3] = {
    /*               fg          bg       border   */
    [SchemeNorm] = { gruvfg4,    gruvbg,  gruvbg3 },
    [SchemeSel]  = { gruvfg,     gruvbg,  gruvorange1 },
    [SchemeUrg]  = { gruvfg,     gruvred, gruvred1 },
};

static const unsigned int alphas[][3] = {
    /*               fg      bg        border     */
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
    [SchemeSel]  = { OPAQUE, baralpha, borderalpha },
    [SchemeUrg]  = { OPAQUE, baralpha, borderalpha },
};
```

**Step 3: Update font to DankMono**

```c
static const char *fonts[]    = { "DankMono Nerd Font:size=22:antialias=true:autohint=false" };
static const char dmenufont[] = "DankMono Nerd Font:size=22:antialias=true:autohint=false";
```

**Step 4: Update tag icons**

```c
static const char *tags[] = { " ", " 󰈹", " ", " ", " 󰕼", " 󰍩", " 󰎆", " ", " 󰇮" };
```

**Step 5: Update TERMINAL and BROWSER**

Find and update:

```c
#define TERMINAL "kitty"
#define BROWSER  "qutebrowser"
```

Or if using spawn commands, update the relevant `SHCMD()` calls.

**Step 6: Build and install dwm**

```bash
cd ~/dotfiles/suckless/src/dwm
cp ~/dotfiles/suckless/dwm/config.h config.h
sudo make clean install
```

---

### Task 6: Update dwmblocks to 6 Blocks with status2d Colors

**Files:**
- Modify: `~/dotfiles/suckless/dwmblocks/blocks.h`
- Modify: `~/dotfiles/scripts/statusbar/sb-cpu`
- Modify: `~/dotfiles/scripts/statusbar/sb-memory`
- Modify: `~/dotfiles/scripts/statusbar/sb-internet`
- Modify: `~/dotfiles/scripts/statusbar/sb-volume`
- Modify: `~/dotfiles/scripts/statusbar/sb-battery`
- Modify: `~/dotfiles/scripts/statusbar/sb-clock`

**Step 1: Update blocks.h to 6 essential blocks**

```c
static const Block blocks[] = {
    /* icon    command        interval  signal */
    { "",     "sb-cpu",       5,        0  },
    { "",     "sb-memory",    10,       0  },
    { "",     "sb-internet",  5,        4  },
    { "",     "sb-volume",    0,        10 },
    { "",     "sb-battery",   30,       3  },
    { "",     "sb-clock",     60,       1  },
};

static char delim[] = " ";
static unsigned int delimLen = 1;
```

**Step 2: Update each statusbar script to output status2d color codes**

Each script should wrap its output with `^c#COLOR^` prefix and `^d^` reset suffix.

Example pattern for sb-cpu:

```bash
#!/bin/sh
CPU=$(awk '/^cpu /{u=$2+$4; t=$2+$4+$5; if(NR>1) printf "%.0f", (u-ou)*100/(t-ot); ou=u; ot=t}' <(cat /proc/stat; sleep 1; cat /proc/stat))
printf "^c#fb4934^ %s%%^d^" "$CPU"
```

Example pattern for sb-clock:

```bash
#!/bin/sh
printf "^c#fabd2f^󰥔 %s^d^" "$(date '+%a %d %b %H:%M')"
```

Repeat this pattern for each script with its designated color:
- sb-cpu: `^c#fb4934^` (red)
- sb-memory: `^c#fe8019^` (orange)
- sb-internet: `^c#83a598^` (blue)
- sb-volume: `^c#8ec07c^` (aqua)
- sb-battery: `^c#b8bb26^` (green)
- sb-clock: `^c#fabd2f^` (yellow)

**Step 3: Build and install dwmblocks**

```bash
cd ~/dotfiles/suckless/src/dwmblocks
cp ~/dotfiles/suckless/dwmblocks/blocks.h blocks.h
sudo make clean install
```

**Step 4: Install statusbar scripts**

```bash
bash ~/dotfiles/scripts/install-statusbar.sh
```

---

### Task 7: Update st config.h

**Files:**
- Modify: `~/dotfiles/suckless/st/config.h`

**Step 1: Update font**

```c
static char *font = "DankMono Nerd Font:size=22:antialias=true:autohint=false";
```

**Step 2: Update colors to Gruvbox Baby ultra-dark**

Update the color array and default colors:

```c
static const char *colorname[] = {
    /* 8 normal colors */
    [0] = "#0d0e0f",   /* black (bg) */
    [1] = "#cc241d",   /* red */
    [2] = "#98971a",   /* green */
    [3] = "#d79921",   /* yellow */
    [4] = "#458588",   /* blue */
    [5] = "#b16286",   /* magenta */
    [6] = "#689d6a",   /* cyan */
    [7] = "#a89984",   /* white */

    /* 8 bright colors */
    [8]  = "#928374",  /* bright black */
    [9]  = "#fb4934",  /* bright red */
    [10] = "#b8bb26",  /* bright green */
    [11] = "#fabd2f",  /* bright yellow */
    [12] = "#83a598",  /* bright blue */
    [13] = "#d3869b",  /* bright magenta */
    [14] = "#8ec07c",  /* bright cyan */
    [15] = "#ebdbb2",  /* bright white */

    [256] = "#ebdbb2", /* cursor */
    [257] = "#555555", /* reverse cursor */
    [258] = "#ebdbb2", /* foreground */
    [259] = "#0d0e0f", /* background */
};

unsigned int defaultfg = 258;
unsigned int defaultbg = 259;
unsigned int defaultcs = 256;
unsigned int defaultrcs = 257;
```

**Step 3: Build and install st**

```bash
cd ~/dotfiles/suckless/src/st
cp ~/dotfiles/suckless/st/config.h config.h
sudo make clean install
```

---

### Task 8: Update dmenu config.h

**Files:**
- Modify: `~/dotfiles/suckless/dmenu/config.h`

**Step 1: Update font and colors**

```c
static const char *fonts[] = { "DankMono Nerd Font:size=22:antialias=true:autohint=false" };

static const char *colors[SchemeLast][2] = {
    /*               fg          bg       */
    [SchemeNorm] = { "#ebdbb2",  "#0d0e0f" },
    [SchemeSel]  = { "#0d0e0f",  "#fe8019" },
    [SchemeOut]  = { "#0d0e0f",  "#83a598" },
};
```

**Step 2: Build and install dmenu**

```bash
cd ~/dotfiles/suckless/src/dmenu
cp ~/dotfiles/suckless/dmenu/config.h config.h
sudo make clean install
```

---

## Phase 3: Compositor + Visual Effects

### Task 9: Picom v12 Glassmorphism Config

**Files:**
- Modify: `~/dotfiles/picom.conf`
- Stow target: `~/.config/picom/picom.conf`

**Step 1: Write complete picom.conf**

Replace `~/dotfiles/picom.conf` with the full glassmorphism config from the design doc. Key settings:

- `backend = "glx"`
- `vsync = false` (XLibre TearFree handles it)
- `blur: { method = "dual_kawase"; strength = 5; }`
- `corner-radius = 14`
- Animations: fly-in/out for open/close, slide for show/hide
- Opacity rules for kitty (85%/75%), st (85%/75%), dmenu (85%), bar (88%)
- Exclude bar and dmenu from corner rounding
- Exclude Dunst from corner rounding (dunst handles its own)
- `unredir-if-possible = true` for fullscreen performance

**Step 2: Restow picom config**

```bash
cd ~/dotfiles/stow && stow -R picom
```

---

## Phase 4: Terminal + Browser + Notifications

### Task 10: Kitty Configuration

**Files:**
- Create: `~/dotfiles/stow/kitty/.config/kitty/kitty.conf`

**Step 1: Create kitty config with Gruvbox Baby + DankMono**

Key settings:
- `font_family DankMono Nerd Font`
- `font_size 16.0`
- `background #0d0e0f`, `foreground #ebdbb2`
- `background_opacity 0.85`
- All 16 Gruvbox colors
- `cursor #fe8019` (orange accent)
- `shell /usr/bin/zsh`
- `hide_window_decorations yes`
- `confirm_os_window_close 0`
- Tab bar: powerline slanted style, Gruvbox colors
- Keybindings: vim-style splits and tabs

**Step 2: Stow kitty config**

```bash
cd ~/dotfiles/stow && stow kitty
```

---

### Task 11: Qutebrowser Full Rice

**Files:**
- Create: `~/dotfiles/stow/qutebrowser/.config/qutebrowser/config.py`
- Create: `~/dotfiles/stow/qutebrowser/.config/qutebrowser/gruvbox.py`
- Create: `~/dotfiles/stow/qutebrowser/.config/qutebrowser/startpage/index.html`

**Step 1: Create gruvbox.py theme file**

Use The-Compiler's gruvbox.py but change `bg0 = bg0_hard` and override bg0_hard to `#0d0e0f`.

**Step 2: Create config.py**

Full config with:
- DankMono Nerd Font 12pt
- Source gruvbox.py theme
- Custom startpage
- Search engines (duckduckgo default + shortcuts)
- Ad blocking (both + hosts)
- Privacy hardening
- Vim keybindings enhancements
- mpv integration, pass integration
- Chromium dark mode enabled
- `c.colors.webpage.bg = '#0d0e0f'`

**Step 3: Create HTML startpage**

Gruvbox-themed startpage with clock, date, and bookmark grid.

**Step 4: Set as default browser**

```bash
xdg-settings set default-web-browser org.qutebrowser.qutebrowser.desktop
```

**Step 5: Stow qutebrowser config**

```bash
cd ~/dotfiles/stow && stow qutebrowser
```

---

### Task 12: Dunst Glassmorphism Notifications

**Files:**
- Modify: `~/dotfiles/stow/dunst/.config/dunst/dunstrc`

**Step 1: Write complete dunstrc**

Key settings:
- `font = DankMono Nerd Font 11`
- `corner_radius = 12`
- `frame_width = 2`, `frame_color = "#fe8019"`
- `gap_size = 6`
- `origin = top-right`, `offset = (12, 36)`
- `transparency = 0` (picom handles it)
- `icon_theme = "Papirus-Dark"`
- Urgency colors: low=#141617, normal=#1d2021, critical=#282828+red
- App rules for volume/brightness/music/chat
- Progress bar styling

**Step 2: Create volume/brightness notification helper scripts**

Create `~/.local/bin/volume-notify.sh` and `~/.local/bin/brightness-notify.sh` with stack-tag dedup.

**Step 3: Restow dunst config**

```bash
cd ~/dotfiles/stow && stow -R dunst
killall dunst 2>/dev/null; dunst &
```

---

## Phase 5: Terminal App Theming

### Task 13: btop Gruvbox + Custom Layout

**Files:**
- Create: `~/dotfiles/stow/btop/.config/btop/btop.conf`
- Create: `~/dotfiles/stow/btop/.config/btop/themes/gruvbox-baby.theme`

**Step 1: Create Gruvbox Baby theme for btop**

Theme file with all Gruvbox Baby colors mapped to btop's theme format.

**Step 2: Create btop.conf**

```ini
color_theme = "gruvbox-baby"
theme_background = False
shown_boxes = "cpu mem net proc"
update_ms = 2000
proc_sorting = "cpu lazy"
cpu_graph_upper = "total"
cpu_graph_lower = "user"
```

**Step 3: Stow btop config**

```bash
cd ~/dotfiles/stow && stow btop
```

---

### Task 14: Other Terminal App Theming

**Files:**
- Create: `~/dotfiles/stow/newsboat/.config/newsboat/config`
- Create: `~/dotfiles/stow/zathura/.config/zathura/zathurarc`
- Modify: `~/dotfiles/zsh/.zshrc` (yazi wrapper, fzf bg, env vars)

**Step 1: Newsboat Gruvbox config**

```
color background          color223   default
color listnormal          color223   default
color listnormal_unread   color142   default  bold
color listfocus           color223   color237 bold
color listfocus_unread    color142   color237 bold
color info                color248   color237
color article             color223   default
```

**Step 2: Zathura Gruvbox config**

```
set default-bg "#0d0e0f"
set default-fg "#ebdbb2"
set statusbar-bg "#282828"
set statusbar-fg "#ebdbb2"
set inputbar-bg "#282828"
set inputbar-fg "#ebdbb2"
set recolor true
set recolor-darkcolor "#ebdbb2"
set recolor-lightcolor "#0d0e0f"
set font "DankMono Nerd Font 12"
```

**Step 3: Update .zshrc**

- Set `TERMINAL=kitty`
- Set `BROWSER=qutebrowser`
- Update fzf `--color` to use `bg:#0d0e0f`
- Add yazi shell wrapper function (cd on exit)
- Create `~/dotfiles/stow/yazi/.config/yazi/theme.toml` with Gruvbox Baby colors
- Create `~/dotfiles/stow/yazi/.config/yazi/yazi.toml` with DankMono font + preferences

**Step 4: Stow new configs**

```bash
cd ~/dotfiles/stow && stow newsboat zathura yazi
```

---

## Phase 6: Emacs + Wallpapers

### Task 15: Emacs Dashboard

**Files:**
- Modify: `~/dotfiles/emacs/` (init.el or config.org)

**Step 1: Install dashboard package**

Add to Emacs config:

```elisp
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-items '((recents . 8)
                           (agenda . 5)
                           (bookmarks . 5)))
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (dashboard-setup-startup-hook))
```

**Step 2: Add keybinding cheatsheet section**

Create a custom dashboard widget showing dwm and Emacs keybindings.

---

### Task 16: Wallpaper Curation

**Files:**
- Modify: `~/dotfiles/xinitrc/.xinitrc` (feh command)

**Step 1: Download curated Gruvbox wallpapers**

```bash
mkdir -p ~/Pictures/wallpapers/gruvbox
cd ~/Pictures/wallpapers/gruvbox
# Download from gruvbox-wallpapers.pages.dev
# Select 20-30 dark, high-res wallpapers
```

**Step 2: Update xinitrc feh command**

```bash
feh --bg-fill --randomize ~/Pictures/wallpapers/gruvbox/ &
```

**Step 3: Restow xinitrc**

```bash
cd ~/dotfiles/stow && stow -R xinitrc
```

---

## Phase 7: Final Integration

### Task 17: Update xinitrc for New Stack

**Files:**
- Modify: `~/dotfiles/xinitrc/.xinitrc`

**Step 1: Update xinitrc to launch new components**

Ensure the startup sequence includes:
1. `xrdb -merge ~/.Xresources`
2. Keyboard remaps
3. Picom with new config
4. Wallpaper (feh --randomize gruvbox/)
5. dunst (new config)
6. dwmblocks (new 6-block config)
7. clipmenud
8. `exec dwm`

---

### Task 18: Update patch-profile.txt and Build All

**Files:**
- Modify: `~/dotfiles/suckless/patch-profile.txt`

**Step 1: Update patch profile**

```
dwm patches:
- cfacts + vanitygaps
- pertag_with_sel
- autostart
- hide_vacant_tags
- actualfullscreen
- movestack
- barpadding
- statuscmd (with barpadding compat)
- status2d
- alpha + fixborders

status: dwmblocks (6 rainbow blocks, clickable)
launcher: dmenu
terminal: kitty primary + st fallback
browser: qutebrowser
```

**Step 2: Full suckless rebuild**

```bash
cd ~/dotfiles && bash scripts/build-suckless-from-source.sh all
```

**Step 3: Restart dwm**

Press `Mod4+Ctrl+r` (restartsig patch) to restart dwm without logging out, or log out and back in.

---

### Task 19: Smoke Test Everything

**Step 1: Verify visuals**

- [ ] dwm bar shows with transparency + blur behind
- [ ] Tag icons render (Nerd Font glyphs)
- [ ] Status blocks show colored icons + text
- [ ] Window borders are orange when focused
- [ ] Background is near-black `#0d0e0f`

**Step 2: Verify functionality**

- [ ] `Mod4+Return` opens kitty (not st)
- [ ] kitty is transparent with blur
- [ ] `Mod4+w` or browser key opens qutebrowser
- [ ] qutebrowser shows Gruvbox startpage
- [ ] Notifications appear with rounded corners + blur
- [ ] `dunstify -h int:value:50 "Test" "Progress"` shows colored progress bar
- [ ] btop shows Gruvbox theme with all 4 panels
- [ ] Wallpaper rotates on login (check .fehbg)
- [ ] DankMono renders smooth (no hinting artifacts)

**Step 3: Verify defaults**

- [ ] `echo $SHELL` returns `/usr/bin/zsh`
- [ ] `echo $TERMINAL` returns `kitty`
- [ ] `echo $BROWSER` returns `qutebrowser`
- [ ] `xdg-settings get default-web-browser` returns qutebrowser
- [ ] `fc-match monospace` returns DankMono

**Step 4: Commit all changes**

```bash
cd ~/dotfiles
git add -A
git commit -m "feat: full desktop rice - Gruvbox Baby ultra-dark glassmorphism"
```

---

## Task Dependency Graph

```
Phase 1 (Foundation):  T1 → T2, T3    (parallel: T2 and T3 are independent)
Phase 2 (Suckless):    T4 → T5 → T6   (sequential: patches before config before blocks)
                       T7, T8          (parallel with T5: independent builds)
Phase 3 (Compositor):  T9              (after T4-T8: needs alpha patch in dwm)
Phase 4 (Apps):        T10, T11, T12   (all parallel, independent)
Phase 5 (Theming):     T13, T14        (parallel, independent)
Phase 6 (Emacs+Wall):  T15, T16        (parallel, independent)
Phase 7 (Integration): T17 → T18 → T19 (sequential: final assembly)
```

**Maximum parallelism:** Tasks 2+3, Tasks 7+8, Tasks 10+11+12, Tasks 13+14, Tasks 15+16 can all run in parallel within their phase.
