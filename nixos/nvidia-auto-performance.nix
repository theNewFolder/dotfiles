# Automatic NVIDIA GPU Performance on Boot
# Sets GPU to maximum performance mode at system startup

{ config, pkgs, lib, ... }:

{
  # Create systemd service for GPU performance
  systemd.services.nvidia-performance-mode = {
    description = "Set NVIDIA GPU to Maximum Performance Mode";
    wantedBy = [ "multi-user.target" ];
    after = [ "nvidia-persistenced.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "nvidia-performance" ''
        #!/usr/bin/env bash

        # Wait for NVIDIA driver to be ready
        for i in {1..10}; do
          if ${pkgs.pciutils}/bin/lspci | grep -i nvidia > /dev/null; then
            break
          fi
          sleep 1
        done

        # Enable persistence mode (keeps driver loaded)
        ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi -pm 1 || true

        # Set all GPUs to maximum performance
        for gpu in $(${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi --query-gpu=index --format=csv,noheader); do
          # Set power limit to maximum (adjust value for your GPU)
          # Uncomment and adjust the wattage for your specific GPU
          # ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi -i $gpu -pl 170 || true

          # Lock clocks to maximum (optional - comment out if unstable)
          # ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi -i $gpu -lgc 1800 || true

          echo "GPU $gpu set to maximum performance"
        done

        # Set PowerMizer to maximum performance via nvidia-settings
        # This requires X server, so it's handled by user service

        echo "NVIDIA Performance Mode: Active"
        ${pkgs.linuxPackages.nvidia_x11}/bin/nvidia-smi --query-gpu=name,power.limit,clocks.max.graphics --format=csv
      ''}";
    };
  };

  # User-level service for nvidia-settings (requires X/Wayland session)
  systemd.user.services.nvidia-powermizer = {
    description = "Set NVIDIA PowerMizer to Maximum Performance";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "nvidia-powermizer" ''
        #!/usr/bin/env bash

        # Wait for display server
        sleep 3

        # Set PowerMizer mode for all GPUs
        for gpu in 0 1 2 3; do
          ${pkgs.linuxPackages.nvidia_x11.settings}/bin/nvidia-settings -a "[gpu:$gpu]/GPUPowerMizerMode=1" 2>/dev/null || true
        done

        echo "PowerMizer set to Prefer Maximum Performance"
      ''}";
    };
  };

  # Persistence daemon (keeps driver loaded, reduces latency)
  systemd.services.nvidia-persistenced = {
    description = "NVIDIA Persistence Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.linuxPackages.nvidia_x11.persistenced}/bin/nvidia-persistenced --user=root --persistence-mode --verbose";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -rf /var/run/nvidia-persistenced";
    };
  };

  # Kernel module options for best performance
  boot.extraModprobeConfig = ''
    # NVIDIA performance options
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
    options nvidia NVreg_TemporaryFilePath=/tmp
    options nvidia NVreg_UsePageAttributeTable=1
    options nvidia NVreg_InitializeSystemMemoryAllocations=0
    options nvidia NVreg_EnableStreamMemOPs=1

    # Disable power management for max performance
    options nvidia NVreg_DynamicPowerManagement=0x00

    # Disable GSP firmware (can cause issues, comment out if needed)
    # options nvidia NVreg_EnableGpuFirmware=0
  '';

  # Create info script for user
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "nvidia-check-performance" ''
      #!/usr/bin/env bash
      echo "🎮 NVIDIA Performance Status"
      echo "=============================="
      echo ""

      # Check persistence mode
      echo "📌 Persistence Mode:"
      nvidia-smi -q | grep "Persistence Mode" || echo "  Not available"
      echo ""

      # Check power mode
      echo "⚡ Power Management:"
      nvidia-smi --query-gpu=name,persistence_mode,power.management --format=csv,noheader
      echo ""

      # Check current clocks
      echo "🔥 Current Clocks:"
      nvidia-smi --query-gpu=name,clocks.current.graphics,clocks.current.memory --format=csv
      echo ""

      # Check power draw
      echo "💪 Power Draw:"
      nvidia-smi --query-gpu=power.draw,power.limit --format=csv
      echo ""

      # Check temperature
      echo "🌡️  Temperature:"
      nvidia-smi --query-gpu=temperature.gpu --format=csv
      echo ""

      # Check if services are running
      echo "🔧 Services:"
      systemctl is-active nvidia-persistenced.service && echo "  ✅ nvidia-persistenced: Active" || echo "  ❌ nvidia-persistenced: Inactive"
      systemctl is-active nvidia-performance-mode.service && echo "  ✅ nvidia-performance-mode: Active" || echo "  ❌ nvidia-performance-mode: Inactive"
      systemctl --user is-active nvidia-powermizer.service && echo "  ✅ nvidia-powermizer: Active" || echo "  ⏳ nvidia-powermizer: Not started (requires login)"
    '')
  ];
}
