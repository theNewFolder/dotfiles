# Zsh shell configuration

{ config, pkgs, colorScheme, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "";  # Disabled, using Starship instead
      plugins = [
        "git"
        "docker"
        "fzf"
        "kubectl"
        "sudo"
        "command-not-found"
        "colored-man-pages"
        "extract"
        "z"  # Jump to frequent directories
      ];
    };

    history = {
      size = 100000;
      save = 100000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    sessionVariables = {
      # EDITOR is set by services.emacs.defaultEditor in emacs.nix
      # VISUAL = "nvim";  # Let Emacs be the visual editor too
      PAGER = "bat --style=plain";
    };

    shellAliases = {
      # Modern CLI replacements
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first";
      lt = "eza --tree --icons -L 2";
      la = "eza -a --icons --group-directories-first";
      cat = "bat --style=plain";
      top = "btm";

      # Git aliases
      g = "git";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      glog = "git log --oneline --graph --decorate -10";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      c = "clear";

      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#tuxnix";
      update = "cd ~/dotfiles && nix flake update && rebuild";
      cleanup = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      # Emacs
      e = "emacsclient -c -a emacs";
      et = "emacsclient -t -a emacs";

      # Quick edit configs
      nixconf = "nvim ~/dotfiles/nixos/configuration.nix";
      homeconf = "nvim ~/dotfiles/home-manager/home.nix";
      zshconf = "nvim ~/dotfiles/home-manager/programs/zsh.nix";
    };

    initContent = ''
      # Load secrets if they exist
      [[ -f ~/.secrets/gemini_api_key ]] && export GEMINI_API_KEY=$(cat ~/.secrets/gemini_api_key)
      [[ -f ~/.secrets/anthropic_api_key ]] && export ANTHROPIC_API_KEY=$(cat ~/.secrets/anthropic_api_key)
      [[ -f ~/.secrets/openai_api_key ]] && export OPENAI_API_KEY=$(cat ~/.secrets/openai_api_key)

      # FZF Gruvbox theme
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
      export FZF_DEFAULT_OPTS='
        --height 40% --layout=reverse --border
        --color=bg+:${colorScheme.bg1},bg:${colorScheme.bg},spinner:${colorScheme.bright_red},hl:${colorScheme.gray}
        --color=fg:${colorScheme.fg},header:${colorScheme.gray},info:${colorScheme.bright_aqua},pointer:${colorScheme.bright_red}
        --color=marker:${colorScheme.bright_red},fg+:${colorScheme.fg},prompt:${colorScheme.bright_red},hl+:${colorScheme.bright_red}'

      # Useful functions
      mkcd() { mkdir -p "$1" && cd "$1"; }
      ff() { fd --type f --hidden "$1" . 2>/dev/null; }
      ffd() { fd --type d --hidden "$1" . 2>/dev/null; }

      # Extract any archive
      extract() {
        if [[ -f "$1" ]]; then
          case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.7z)      7z x "$1" ;;
            *.rar)     unrar x "$1" ;;
            *)         echo "Unknown archive format: $1" ;;
          esac
        else
          echo "File not found: $1"
        fi
      }

      # Keybindings for history search
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
    '';
  };

  # FZF integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
