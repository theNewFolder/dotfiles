#!/usr/bin/env bash
set -euo pipefail
sudo powertop --calibrate
sudo powertop --html="$HOME/powertop-report.html"
sudo powertop --auto-tune > "$HOME/powertop-auto-tune.txt" 2>&1
echo "Saved:"
echo "  $HOME/powertop-report.html"
echo "  $HOME/powertop-auto-tune.txt"
