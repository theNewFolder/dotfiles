#!/usr/bin/env bash
set -euo pipefail

# Lightweight scratchpad toggle without extra dwm patches:
# - if a scratch terminal exists, kill it
# - otherwise start one with dedicated WM instance "spterm"
if pgrep -f "st -n spterm -g 120x34" >/dev/null 2>&1; then
  pkill -f "st -n spterm -g 120x34"
else
  st -n spterm -g 120x34 >/dev/null 2>&1 &
fi
