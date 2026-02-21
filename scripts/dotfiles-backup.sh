#!/bin/sh
# Dotfiles backup — commit and push to GitHub
# Usage: dotfiles-backup [message]

set -e

DOTDIR="$HOME/dotfiles"
BRANCH="main"
REMOTE="origin"

cd "$DOTDIR"

# Check if remote exists
if ! git remote get-url "$REMOTE" >/dev/null 2>&1; then
    echo "No remote '$REMOTE' configured."
    echo "Run: gh repo create dotfiles --private --source=. --push"
    exit 1
fi

# Check for changes
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "Nothing to backup — working tree clean."
    exit 0
fi

# Stage all changes
git add -A

# Commit with message or auto-generate
MSG="${1:-"backup: $(date '+%Y-%m-%d %I:%M %p')"}"
git commit -m "$MSG"

# Push
git push "$REMOTE" "$BRANCH"

echo "Dotfiles backed up to GitHub."
