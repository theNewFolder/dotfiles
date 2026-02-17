# Essential applications and helpers for daily use, development, and gaming

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ===== Development Tools =====
    # Code editors
    vscode
    helix

    # Version control
    git-lfs
    lazygit
    tig

    # Build tools
    gnumake
    cmake
    meson
    ninja

    # Programming languages
    gcc
    python3
    python3Packages.pip
    python3Packages.virtualenv
    poetry  # Python package manager
    # nodejs, npm, yarn - all provided by mcp-servers.nix
    go
    rustup

    # ===== Terminal Utilities =====
    # Modern replacements
    bat         # cat replacement
    eza         # ls replacement
    ripgrep     # grep replacement
    fd          # find replacement
    sd          # sed replacement
    bottom      # top replacement
    dust        # du replacement
    duf         # df replacement
    procs       # ps replacement

    # File managers
    yazi        # Terminal file manager
    ranger      # Another TUI file manager
    nnn         # Minimal file manager

    # Productivity
    tmux        # Terminal multiplexer
    zellij      # Modern tmux alternative
    # tldr - using tealdeer instead (faster)
    cheat       # Cheatsheets
    tealdeer    # Fast tldr client

    # Network tools
    wget
    curl
    aria2       # Download manager
    rsync
    nmap
    iperf3
    bandwhich   # Network utilization
    dog         # DNS client (dig alternative)

    # ===== Media & Graphics =====
    # Image viewers/editors
    imv         # Wayland image viewer
    feh         # X11 image viewer
    gimp        # Image editor
    inkscape    # Vector graphics

    # Video
    mpv         # Video player
    vlc         # Alternative video player
    ffmpeg      # Video processing
    obs-studio  # Screen recording/streaming

    # Audio
    pavucontrol # PulseAudio volume control
    easyeffects # Audio effects
    audacity    # Audio editor

    # ===== Gaming =====
    # Game launchers
    lutris      # Multi-platform game launcher
    heroic      # Epic/GOG launcher
    bottles     # Wine manager

    # Gaming utilities
    mangohud    # Performance overlay
    goverlay    # MangoHud configurator

    # Emulators
    retroarch   # Multi-system emulator

    # ===== Productivity =====
    # Note-taking (beyond Emacs)
    obsidian    # Knowledge base
    logseq      # Outliner and knowledge base

    # PDF tools
    zathura     # Minimal PDF viewer
    evince      # PDF viewer
    pdfarranger # PDF editor

    # Office
    libreoffice-fresh

    # Communication
    discord
    telegram-desktop
    slack

    # ===== System Utilities =====
    # System monitoring
    htop
    btop
    iotop
    nvtopPackages.nvidia

    # Disk utilities
    gparted
    gnome-disk-utility

    # Archive tools
    unzip
    p7zip
    unrar
    zip

    # File sync
    syncthing   # P2P file sync
    rclone      # Cloud storage sync

    # ===== Security =====
    keepassxc   # Password manager
    bitwarden-cli

    # ===== Fonts (Additional) =====
    font-awesome
    material-design-icons
    noto-fonts-emoji-blob-bin  # Better emoji support

    # ===== Wayland Utilities =====
    wdisplays   # Display configuration
    wlr-randr   # Display info
    wayland-utils
    xwayland    # X11 app support

    # ===== Browser Extensions Helper =====
    browserpass  # Browser integration for pass

    # ===== Clipboard Manager =====
    wl-clipboard
    cliphist     # Clipboard history

    # ===== Screenshot Tools =====
    swappy      # Screenshot annotation
    flameshot   # Screenshot tool

    # ===== Screen Color Management =====
    wlsunset    # Gamma adjustment (day/night)
    # wl-gammarelay  # Manual gamma control (if needed)

    # ===== Benchmarking =====
    hyperfine   # Command-line benchmarking
    stress      # System stress testing
    s-tui       # CPU stress test UI

    # ===== Containers & VMs =====
    docker-compose
    podman
    distrobox   # Run other distros

    # ===== AI & Machine Learning =====
    # Python ML packages handled via pip/venv

    # ===== Misc Utilities =====
    tree        # Directory tree
    jq          # JSON processor
    yq          # YAML processor
    fx          # JSON viewer
    github-cli  # GitHub CLI
    neofetch    # System info
    fastfetch   # Faster neofetch
    lolcat      # Colorful cat
    cmatrix     # Matrix effect
    pipes-rs    # Animated pipes

    # File search
    fzf         # Fuzzy finder
    skim        # Alternative to fzf

    # Backup
    restic      # Backup tool
    borgbackup  # Deduplicating backup

    # ===== Learning & Documentation =====
    man-pages
    man-pages-posix
    # tldr-pages already included via tealdeer

    # ===== Gaming Performance =====
    gamemode    # Optimize system for gaming
  ];

  # Enable gaming-related programs
  programs = {
    # Steam (configured in system)

    # Discord rich presence
    # discordrpc.enable = true;  # If available
  };

  # XDG MIME associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
    };
  };
}
