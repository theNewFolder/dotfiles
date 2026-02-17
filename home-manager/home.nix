# Home Manager configuration for user 'dev'
# Rebuild with: sudo nixos-rebuild switch --flake ~/dotfiles#tuxnix

{ config, pkgs, ... }:

{
  # ===== User Info =====
  home.username = "dev";
  home.homeDirectory = "/home/dev";

  # ===== State Version =====
  # Do NOT change this value
  home.stateVersion = "26.05";

  # ===== Imports =====
  imports = [
    ./themes/gruvbox.nix
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/emacs.nix
    ./programs/firefox.nix
    ./programs/niri.nix
    ./programs/foot.nix
    ./programs/mcp-servers.nix
    ./applications.nix
  ];

  # ===== Packages =====
  home.packages = with pkgs; [
    # Terminal emulators
    wezterm
    kitty
    foot

    # Modern CLI tools
    ripgrep
    fd
    bat
    eza
    fzf
    bottom
    htop
    dust
    procs
    tokei
    hyperfine
    delta
    zoxide

    # File managers
    yazi
    ranger

    # Network tools
    wget
    curl
    aria2

    # Archive tools
    unzip
    p7zip
    unrar

    # Media
    mpv
    imv
    ffmpeg

    # Development
    nodejs
    python3
    rustc
    cargo

    # Note-taking & PKM
    obsidian
    zathura  # PDF viewer

    # Screenshots
    grim
    slurp
    swappy

    # System monitoring
    btop
    # nvtop  # GPU monitoring - may need specific package
    # iotop  # IO monitoring - btop provides similar functionality

    # Utilities
    tree
    jq
    yq
    tldr
    man-pages
    neofetch
  ];

  # ===== XDG =====
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };
  };

  # ===== Session Variables =====
  home.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";

    # Editor - set by services.emacs.defaultEditor in emacs.nix

    # Path additions
    PATH = "$HOME/.local/bin:$HOME/bin:$PATH";
  };

  # ===== Git Clone Dotfiles Backup =====
  # Keep old claud directory as reference
  home.file."README-dotfiles.md".text = ''
    # NixOS Dotfiles

    This system is now managed by NixOS with home-manager flakes.

    ## Directory Structure
    - `~/dotfiles/` - New flake-based NixOS config (active)
    - `~/claud/` - Previous CachyOS literate config (reference)

    ## Quick Commands
    - Rebuild system: `rebuild`
    - Update flake: `update`
    - Clean old generations: `cleanup`
    - Edit NixOS config: `nixconf`
    - Edit home-manager: `homeconf`

    ## Org-mode Notes
    - Main org directory: `~/org/`
    - Org-roam: `~/org/roam/`
    - PKM notes: `~/dotfiles/docs/notes.org`

    ## AI Tools
    - Claude CLI: `~/claud/claude` (add to PATH)
    - Gemini CLI: Install with `npm install -g @google/generative-ai-cli`
    - API keys: `~/.secrets/`

    ## Window Manager
    - Primary: Niri (Wayland scrollable-tiling compositor)
    - Fallback: GNOME (select at GDM login screen)

    ## Documentation
    - NixOS manual: `nixos-help`
    - Home-manager: https://nix-community.github.io/home-manager/
    - Niri docs: https://github.com/niri-wm/niri/wiki
  '';

  # ===== Let home-manager manage itself =====
  programs.home-manager.enable = true;
}
