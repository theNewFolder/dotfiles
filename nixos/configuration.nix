# NixOS system configuration for tuxnix
# Edit this file, then rebuild with: sudo nixos-rebuild switch --flake ~/dotfiles#tuxnix

{ config, lib, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
    # Gaming and performance optimizations for TUF laptop
    ./gaming-optimizations.nix
    # Maximum GPU performance
    ./gpu-performance.nix
    # Auto-enable GPU performance on boot
    ./nvidia-auto-performance.nix
  ];

  # ===== Boot =====
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ===== Networking =====
  networking.hostName = "tuxnix";
  networking.networkmanager.enable = true;

  # ===== Nix Settings =====
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  # ===== Localization =====
  time.timeZone = "Asia/Dubai";
  i18n.defaultLocale = "en_US.UTF-8";

  # ===== Display & Desktop =====
  services.xserver.enable = true;

  # GNOME (fallback desktop)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Niri Wayland compositor (main WM)
  programs.niri.enable = true;

  # ===== Graphics =====
  # NVIDIA GPU
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };
  hardware.graphics.enable = true;

  # ===== Audio =====
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ===== Input =====
  services.libinput.enable = true;

  # ===== Filesystem =====
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" "/home" ];
  };

  # ===== Users =====
  users.users.dev = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # ===== System Packages =====
  environment.systemPackages = with pkgs; [
    # Essentials
    vim neovim wget curl git gh

    # Modern CLI tools
    ripgrep fd bat eza fzf bottom htop

    # Btrfs tools
    btrfs-progs compsize

    # Wayland tools
    wl-clipboard wev

    # Terminal emulators
    kitty wezterm foot

    # Development
    gcc gnumake

    # Niri utilities
    fuzzel mako
  ];

  # ===== Programs =====
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    git.enable = true;
  };

  # ===== Fonts =====
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
  ];

  # ===== Font Rendering (System-wide) =====
  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      style = "slight";
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "light";
    };
  };

  # FreeType settings for better rendering
  fonts.fontDir.enable = true;

  # ===== Security =====
  security.sudo.wheelNeedsPassword = true;

  # ===== Version =====
  # Do NOT change this value
  system.stateVersion = "26.05";
}
