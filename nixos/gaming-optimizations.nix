# Gaming and performance optimizations for ASUS TUF Gaming laptop
# AMD CPU + NVIDIA GPU

{ config, pkgs, lib, ... }:

{
  # ===== CPU Performance =====
  # Performance governor for gaming
  powerManagement.cpuFreqGovernor = "performance";

  # AMD CPU optimizations
  boot.kernelParams = [
    # AMD P-state driver for better performance/power balance
    "amd_pstate=active"

    # Disable CPU vulnerabilities mitigations for better performance (gaming)
    "mitigations=off"

    # Increase vm.max_map_count for games
    "vm.max_map_count=2147483642"
  ];

  boot.kernel.sysctl = {
    # Gaming optimizations
    "vm.max_map_count" = 2147483642;  # For games like Elden Ring
    "vm.swappiness" = 10;  # Reduce swap usage
    "kernel.sched_autogroup_enabled" = 0;  # Better for gaming

    # Network performance
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    "net.core.rmem_default" = 1048576;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 1048576;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_mtu_probing" = 1;
  };

  # ===== NVIDIA Optimizations =====
  hardware.nvidia = {
    # Use performance mode
    powerManagement.enable = false;  # Disable power saving for gaming

    # Force Performance Level
    # You can set this to "prefer maximum performance" in nvidia-settings

    # Enable NVIDIA settings app
    nvidiaSettings = true;

    # Use proprietary drivers (best for gaming)
    open = false;
  };

  # Gaming environment variables
  # Note: GPU performance settings are in gpu-performance.nix
  environment.variables = {
    # Gaming environment variables
    DXVK_HUD = "fps";  # Show FPS in games
    PROTON_ENABLE_NVAPI = "1";  # Better NVIDIA support in Proton
    PROTON_HIDE_NVIDIA_GPU = "0";
  };

  # ===== Gaming Packages =====
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;  # Gamescope for better gaming
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      cpu = {
        park_cores = "no";
        pin_cores = "yes";
      };
    };
  };

  # ===== Performance Tools =====
  environment.systemPackages = with pkgs; [
    # Gaming
    gamescope
    mangohud
    gamemode

    # Performance monitoring
    nvtopPackages.nvidia  # NVIDIA GPU monitoring

    # ASUS tools (if available)
    # asusctl  # ASUS laptop control
    # supergfxctl  # GPU switching
  ];

  # ===== Thermal Management =====
  # Better thermal management for gaming laptop
  services.thermald.enable = true;

  # ===== Audio =====
  # Low latency audio for gaming
  services.pipewire = {
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 512;
        };
      };
    };
  };

  # ===== I/O Scheduler =====
  # BFQ scheduler for better gaming performance on NVMe
  services.udev.extraRules = ''
    # NVMe SSD - use none scheduler for best performance
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"

    # For other SSDs
    ACTION=="add|change", SUBSYSTEM=="block", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
  '';

  # ===== Enable 32-bit support for gaming =====
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ===== Firewall for gaming =====
  networking.firewall = {
    enable = true;
    # Common gaming ports
    allowedTCPPortRanges = [
      { from = 27000; to = 27050; }  # Steam
    ];
    allowedUDPPortRanges = [
      { from = 27000; to = 27050; }  # Steam
    ];
  };
}
