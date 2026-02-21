# Repo-guided zsh: minimal, fast, modal.

# Path (deduplicated)
typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/.local/bin/statusbar"
  "$HOME/.local/bin/utils"
  "$HOME/go/bin"
  $path
)

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE
setopt SHARE_HISTORY INC_APPEND_HISTORY

# Shell behavior
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB GLOB_DOTS
setopt NO_BEEP NO_CASE_GLOB

# Completion (cache .zcompdump, rebuild every 24h)
autoload -Uz compinit
if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$HOME/.zcompdump"
else
  compinit -C -d "$HOME/.zcompdump"
fi
{
  if [[ -s "$HOME/.zcompdump" && (! -s "$HOME/.zcompdump.zwc" || "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc") ]]; then
    zcompile "$HOME/.zcompdump"
  fi
} &!

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Vi mode
bindkey -v
KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey -v '^?' backward-delete-char

autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Prompt (starship)
eval "$(starship init zsh)"

# Plugin loader (manual, no framework)
source_if_exists() { [[ -f "$1" ]] && source "$1"; }

# Completions (must be before compinit)
fpath=(~/.local/share/zsh/plugins/zsh-completions/src $fpath)

# fzf-tab (must be after compinit, before other widgets)
source_if_exists ~/.local/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# Autosuggestions
source_if_exists /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists /usr/share/zsh/site-functions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#504945'

# History substring search
source_if_exists /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source_if_exists /usr/share/zsh/site-functions/zsh-history-substring-search.zsh

# Syntax highlighting (fast fork, must be last)
source_if_exists ~/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# fzf-tab preview config
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || eza -1 --color=always $realpath 2>/dev/null'

# fzf
source_if_exists /usr/share/fzf/key-bindings.zsh
source_if_exists /usr/share/fzf/completion.zsh
[[ $- == *i* ]] && source <(fzf --zsh 2>/dev/null) 2>/dev/null
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#3c3836,bg:#0d0e0f,spinner:#fabd2f,hl:#d3869b --color=fg:#ebdbb2,header:#83a598,info:#fabd2f,pointer:#fabd2f --color=marker:#fe8019,fg+:#ebdbb2,prompt:#fabd2f,hl+:#d3869b'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {} 2>/dev/null || ls -la {}' --bind 'ctrl-/:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=1 --icons=auto {} 2>/dev/null | head -50'"

# fzf-git (CTRL-G prefix bindings for branches, commits, tags, etc.)
source_if_exists "$HOME/.local/bin/fzf-git.sh"

# zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# Environment
export EDITOR='emacsclient -t -a emacs'
export VISUAL='emacsclient -c -a emacs'
export BROWSER='firefox'
export TERMINAL='kitty'
export PAGER='less'
export LESS='-R --use-color -Dd+r$Du+b'
export MOZ_USE_XINPUT2=1

# Aliases
alias ..='cd ..'
alias ...='cd ../..'

# Modern CLI (shadow originals)
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -la --icons=auto --group-directories-first'
alias la='eza -A --icons=auto --group-directories-first'
alias lt='eza --tree --level=2 --icons=auto'
alias tree='eza --tree --icons=auto'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias du='dust'
alias diff='delta'
alias top='btop'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate --all'

alias xs='startx'
alias xr='xrdb -merge ~/.Xresources && echo "Xresources reloaded"'

# AI CLIs
alias gm='gemini'
alias cc='claude'

# Dotfiles & GitHub
alias backup='~/dotfiles/scripts/dotfiles-backup.sh'
alias dots='cd ~/dotfiles'

# Suckless workflow
alias sls='cd ~/dotfiles/suckless'
alias smi='sudo make clean install'
alias dwm-edit='$EDITOR ~/dotfiles/suckless/dwm/config.h'
alias st-edit='$EDITOR ~/dotfiles/suckless/st/config.h'
alias dmenu-edit='$EDITOR ~/dotfiles/suckless/dmenu/config.h'

# Helpers
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz)  tar xzf "$1" ;;
    *.tar.xz)  tar xJf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.zip)     unzip "$1" ;;
    *.7z)      7z x "$1" ;;
    *.tar)     tar xf "$1" ;;
    *)         echo "Unknown archive: $1" ;;
  esac
}

# Atuin (replaces ctrl-r)
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow)"

# Direnv
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Bookmarks
[ -f ~/.config/shell/bm-dirs ] && while IFS=$'\t' read -r key dir; do
  alias "g${key}=cd ${dir}"
done < ~/.config/shell/bm-dirs

[ -f ~/.config/shell/bm-files ] && while IFS=$'\t' read -r key file; do
  alias "e${key}=\$EDITOR ${file}"
done < ~/.config/shell/bm-files

# Yazi wrapper (cd on exit)
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Cleanup
unfunction source_if_exists
