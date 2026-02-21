# DWM Research Notes

Curated references used to align this setup with popular and proven workflows.

## Luke Smith ecosystem

- `voidrice` (dotfiles): https://github.com/LukeSmithxyz/voidrice
- `dwm`: https://github.com/lukesmithxyz/dwm
- `dmenu`: https://github.com/LukeSmithxyz/dmenu
- `dwmblocks`: https://github.com/LukeSmithxyz/dwmblocks

## Suckless primary

- Philosophy: https://suckless.org/philosophy/
- DWM tutorial: https://dwm.suckless.org/tutorial/
- DWM patches:
  - pertag: https://dwm.suckless.org/patches/pertag/
  - actualfullscreen: https://dwm.suckless.org/patches/actualfullscreen/
  - autostart: https://dwm.suckless.org/patches/autostart/
  - restartsig: https://dwm.suckless.org/patches/restartsig/
  - swallow: https://dwm.suckless.org/patches/swallow/
- "Rocks" tools list: https://suckless.org/rocks/

## Popular setups and inspiration

- Codeberg minimal setup: https://codeberg.org/justaguylinux/dwm-setup
- Void + ThinkPad setup: https://github.com/unresolvedsymbol/dotfiles
- Documented Void DWM setup: https://github.com/ilhamisbored/dwm
- Additional dotfiles repo: https://github.com/mich-murphy/dwm-dotfiles

## Unixporn / community signal

- Example post: https://www.reddit.com/r/unixporn/comments/f77uaq/dwm_plan9_wannabe/
- DWM search in unixporn: https://www.reddit.com/r/unixporn/search/?q=dwm&restrict_sr=1

## Practical takeaways adopted

- Keep patch set small and intentional.
- Prefer source builds with pinned versions for patch compatibility.
- Keep launcher minimal (`dmenu` primary).
- Use `dwmblocks` for lightweight, scriptable status modules.
- Keep recovery path simple: snapshot source + patch + config before rebuilds.
