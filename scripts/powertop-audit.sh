#!/usr/bin/env bash
set -euo pipefail
printf 'o\n' | sudo -S powertop --calibrate
printf 'o\n' | sudo -S powertop --html="$HOME/powertop-report.html"
printf 'o\n' | sudo -S powertop --auto-tune-dump > "$HOME/powertop-auto-tune.txt"
echo "Saved:"
echo "  $HOME/powertop-report.html"
echo "  $HOME/powertop-auto-tune.txt"
