# GPU monitoring and info scripts

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # GPU monitoring
    nvtopPackages.nvidia
    mesa-demos  # Provides glxinfo and glxgears
    vulkan-tools
  ];

  # GPU info script
  home.file.".local/bin/gpu-info" = {
    text = ''
      #!/usr/bin/env bash
      # Display GPU information

      echo "🎮 GPU Information"
      echo "=================="
      echo ""

      # NVIDIA GPU info
      if command -v nvidia-smi &> /dev/null; then
        echo "📊 NVIDIA GPU Status:"
        nvidia-smi --query-gpu=name,driver_version,memory.total,memory.used,temperature.gpu,utilization.gpu,power.draw --format=csv,noheader,nounits | \
        while IFS=, read -r name driver mem_total mem_used temp util power; do
          echo "  Name: $name"
          echo "  Driver: $driver"
          echo "  Memory: $mem_used MB / $mem_total MB"
          echo "  Temperature: $temp°C"
          echo "  Utilization: $util%"
          echo "  Power: $power W"
        done
        echo ""
      fi

      # OpenGL info
      echo "🎨 OpenGL Renderer:"
      glxinfo | grep "OpenGL renderer"
      glxinfo | grep "OpenGL version"
      echo ""

      # Vulkan info
      echo "🔺 Vulkan Support:"
      vulkaninfo --summary 2>/dev/null | grep -E "(deviceName|driverVersion)" | head -4 || echo "  Vulkan supported"
      echo ""

      # Current performance mode
      if [ -f /sys/class/drm/card0/device/power_dpm_force_performance_level ]; then
        echo "⚡ Performance Mode:"
        cat /sys/class/drm/card0/device/power_dpm_force_performance_level
      fi
    '';
    executable = true;
  };

  # GPU performance mode switcher
  home.file.".local/bin/gpu-performance" = {
    text = ''
      #!/usr/bin/env bash
      # Switch GPU to maximum performance

      echo "🚀 Setting NVIDIA GPU to Maximum Performance"
      echo "============================================"
      echo ""

      # Check if nvidia-settings is available
      if ! command -v nvidia-settings &> /dev/null; then
        echo "❌ nvidia-settings not found"
        exit 1
      fi

      # Set PowerMizer to maximum performance
      nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=1" 2>/dev/null
      echo "✅ PowerMizer set to prefer maximum performance"

      # Enable persistence mode (requires root)
      if command -v nvidia-smi &> /dev/null; then
        sudo nvidia-smi -pm 1 2>/dev/null && echo "✅ Persistence mode enabled" || echo "⚠️  Need root for persistence mode"
      fi

      # Show current status
      echo ""
      echo "📊 Current GPU Status:"
      nvidia-smi --query-gpu=name,clocks.gr,clocks.mem,power.draw,power.limit --format=csv,noheader
    '';
    executable = true;
  };

  # Benchmark script
  home.file.".local/bin/gpu-bench" = {
    text = ''
      #!/usr/bin/env bash
      # Quick GPU benchmark

      echo "🎯 GPU Benchmark"
      echo "==============="
      echo ""

      # GLXGears benchmark
      if command -v glxgears &> /dev/null; then
        echo "Running glxgears for 10 seconds..."
        timeout 10s glxgears 2>&1 | tail -1
        echo ""
      fi

      # Vulkan benchmark (if available)
      if command -v vkcube &> /dev/null; then
        echo "Vulkan cube test available - run manually: vkcube"
      fi

      # Show GPU load
      echo "Current GPU Load:"
      nvidia-smi --query-gpu=utilization.gpu,utilization.memory,temperature.gpu,power.draw --format=csv,noheader
    '';
    executable = true;
  };

  # Shell aliases for GPU
  programs.zsh.shellAliases = {
    gpu = "gpu-info";
    gpuinfo = "nvidia-smi";
    gpuperf = "gpu-performance";
    gpubench = "gpu-bench";
    nvtop = "nvtop";
  };
}
