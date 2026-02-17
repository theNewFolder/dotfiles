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
    ./programs/fontconfig.nix
    ./programs/gpu-info.nix
    ./applications.nix
  ];

  # ===== Packages =====
  home.packages = with pkgs; [
    # ===== Terminal Emulators =====
    foot      # Primary - minimal, fast, Wayland-native
    kitty     # Backup - feature-rich when needed

    # ===== Modern CLI Tools (Rust-based, fast) =====
    ripgrep   # Fast grep alternative
    fd        # Fast find alternative
    bat       # Better cat with syntax highlighting
    eza       # Better ls with colors
    fzf       # Fuzzy finder
    zoxide    # Smart cd
    delta     # Better git diff

    # ===== File Management =====
    yazi      # Modern terminal file manager (Rust)
    ranger    # Python-based file manager
    nnn       # Minimal, fast file manager
    lf        # Simple terminal file manager (Go)

    # ===== System Monitoring =====
    btop      # Beautiful system monitor
    bottom    # Cross-platform system monitor (Rust)
    htop      # Classic process viewer
    bandwhich # Network bandwidth monitor
    procs     # Better ps (Rust)
    dust      # Better du (Rust)

    # ===== Network Tools =====
    wget
    curl
    aria2     # Multi-threaded downloader
    rsync     # File sync

    # ===== Archive Tools =====
    unzip
    p7zip
    unrar
    zstd      # Fast compression

    # ===== Media =====
    mpv       # Minimal video player (suckless philosophy)
    imv       # Minimal image viewer
    ffmpeg    # Media manipulation
    yt-dlp    # Download videos/audio

    # ===== Development Tools =====
    # Languages
    # nodejs - provided by mcp-servers.nix
    python3
    # rustc, cargo - provided by rustup in applications.nix
    go
    gcc
    clang

    # Version Control
    git
    lazygit   # Terminal UI for git
    gh        # GitHub CLI

    # Editors & IDEs
    neovim    # Modal editor (suckless-friendly)
    helix     # Modern modal editor (Rust)

    # Build tools
    gnumake
    cmake
    meson
    ninja

    # Debugging & profiling
    gdb
    valgrind
    strace

    # ===== Learning & Documentation =====
    man-pages
    man-pages-posix
    # tldr - using tealdeer instead (faster Rust implementation)
    tealdeer  # Fast tldr (Rust)
    cheat     # Cheatsheets for CLI

    # Note-taking & PKM
    obsidian  # Markdown-based notes
    zathura   # Minimal PDF viewer (suckless philosophy)
    mupdf     # Lightweight PDF viewer

    # ===== Productivity =====
    # Screenshots & screen tools
    grim      # Screenshot tool
    slurp     # Screen area selector
    swappy    # Screenshot editor
    wl-clipboard  # Clipboard for Wayland

    # Calculators & utilities
    bc        # Calculator
    calc      # Better calculator
    units     # Unit converter

    # Text processing
    jq        # JSON processor
    yq        # YAML processor
    sd        # Better sed (Rust)
    hexyl     # Hex viewer (Rust)

    # ===== System Utilities =====
    tree
    tokei     # Code statistics (Rust)
    hyperfine # Benchmarking (Rust)
    choose    # Better cut/awk (Rust)

    # Fuzzy tools
    fuzzel    # Application launcher (Wayland)

    # Info tools
    neofetch
    fastfetch # Faster neofetch alternative

    # ===== Security & Privacy =====
    age       # Modern encryption
    gnupg     # GPG encryption
    pass      # Password manager (suckless)

    # ===== Fun & Learning =====
    cmatrix   # Matrix effect
    pipes-rs  # Animated pipes (Rust)
    cowsay
    fortune
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

  # ===== GTK Theme =====
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # ===== Qt Theme =====
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # ===== Session Variables =====
  home.sessionVariables = {
    # Wayland
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";

    # HiDPI support
    GDK_SCALE = "1";  # Integer scaling for GTK3
    GDK_DPI_SCALE = "1.0";  # Font scaling for GTK3
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";  # Qt auto-scaling
    QT_SCALE_FACTOR = "1";  # Qt manual scaling
    XCURSOR_SIZE = "32";  # Cursor size for X11 apps

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
