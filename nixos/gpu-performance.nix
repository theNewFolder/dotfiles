# Maximum GPU Performance Configuration
# NVIDIA GPU optimizations for ASUS TUF Gaming laptop

{ config, pkgs, lib, ... }:

{
  # ===== NVIDIA Driver Settings =====
  hardware.nvidia = {
    # Latest production drivers
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Force performance mode
    powerManagement = {
      enable = false;  # Disable power saving
      finegrained = false;  # No dynamic power management
    };

    # Modesetting (required for Wayland)
    modesetting.enable = true;

    # Use proprietary drivers (best performance)
    open = false;

    # Enable NVIDIA settings
    nvidiaSettings = true;

    # Force full composition pipeline (reduces tearing)
    forceFullCompositionPipeline = true;
  };

  # ===== Boot Parameters for GPU =====
  boot.kernelParams = [
    # NVIDIA specific
    "nvidia-drm.modeset=1"  # Enable DRM kernel mode setting
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"  # Better suspend/resume
    "nvidia.NVreg_UsePageAttributeTable=1"  # Better memory performance

    # Disable CPU mitigations for better performance
    "mitigations=off"

    # Increase video memory
    "video=efifb:off"  # Disable EFI framebuffer
  ];

  # Load NVIDIA modules early
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  # ===== Environment Variables =====
  environment.variables = {
    # Force NVIDIA GPU
    __NV_PRIME_RENDER_OFFLOAD = "0";  # Always use NVIDIA (not offload)
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";

    # OpenGL optimizations
    __GL_THREADED_OPTIMIZATION = "1";  # Enable threaded optimizations
    __GL_SHADER_DISK_CACHE = "1";  # Enable shader cache
    __GL_SHADER_DISK_CACHE_PATH = "/tmp/nvidia-shader-cache";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

    # Performance settings
    __GL_SYNC_TO_VBLANK = "0";  # Disable vsync for max FPS
    __GL_MaxFramesAllowed = "1";  # Reduce input lag
    __GL_YIELD = "NOTHING";  # Don't yield CPU

    # G-SYNC / VRR
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";

    # Wayland + NVIDIA
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";  # Fix cursor issues

    # Vulkan
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

    # CUDA (if needed)
    CUDA_CACHE_PATH = "/tmp/cuda-cache";

    # Gaming specific
    PROTON_ENABLE_NVAPI = "1";
    PROTON_ENABLE_NGX_UPDATER = "1";
    DXVK_ASYNC = "1";  # Async shader compilation
    DXVK_STATE_CACHE_PATH = "/tmp/dxvk-cache";
  };

  # ===== System Packages =====
  environment.systemPackages = with pkgs; [
    # NVIDIA tools
    nvtopPackages.nvidia  # GPU monitoring
    libva-utils  # VA-API verification
    vdpauinfo  # VDPAU info
    vulkan-tools  # Vulkan utilities
    mesa-demos  # OpenGL info (glxinfo, glxgears)

    # GPU overclocking (optional)
    # nvidia-overclocking-tool  # If available

    # Performance monitoring
    mangohud  # Gaming overlay
    goverlay  # MangoHud configurator
  ];

  # ===== OpenGL & Vulkan =====
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For 32-bit games

    extraPackages = with pkgs; [
      nvidia-vaapi-driver  # VA-API support
      libva-vdpau-driver
      libvdpau-va-gl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # ===== Services =====
  # Persistence for NVIDIA
  systemd.tmpfiles.rules = [
    "d /tmp/nvidia-shader-cache 0755 root root -"
    "d /tmp/cuda-cache 0755 root root -"
    "d /tmp/dxvk-cache 0755 root root -"
  ];

  # ===== X11 Configuration (for nvidia-settings) =====
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
    Option "AllowIndirectGLXProtocol" "off"
    Option "TripleBuffer" "on"
  '';

  services.xserver.deviceSection = ''
    Option "Coolbits" "28"
    Option "RegistryDwords" "PerfLevelSrc=0x2222"
    Option "TripleBuffer" "True"
    Option "NoFlip" "False"
  '';

  # ===== Overclocking (Advanced - Use with caution) =====
  # Coolbits enables overclocking in nvidia-settings
  # Values:
  #   4 = Enable fan control
  #   8 = Enable overclocking
  #   16 = Enable overvoltage
  #   28 = All of the above (4 + 8 + 16)

  # After setting Coolbits=28, use nvidia-settings:
  # nvidia-settings -a "[gpu:0]/GPUPowerMizerMode=1"  # Max performance
  # nvidia-settings -a "[gpu:0]/GPUGraphicsClockOffsetAllPerformanceLevels=100"
  # nvidia-settings -a "[gpu:0]/GPUMemoryTransferRateOffsetAllPerformanceLevels=200"
}
