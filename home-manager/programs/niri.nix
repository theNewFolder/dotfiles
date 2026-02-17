# Niri Wayland compositor configuration
# Updated: 2026-02-17 - Fixed cursor configuration

{ config, pkgs, colorScheme, ... }:

{
  # Niri config file (KDL format)
  # Note: home-manager doesn't have a programs.niri module yet,
  # so we'll create the config file directly

  xdg.configFile."niri/config.kdl".text = ''
    // Niri configuration - Gruvbox Dark minimal
    // Reload with: niri msg reload-config

    // ===== Input =====
    input {
        keyboard {
            xkb {
                layout "us"
            }
            repeat-delay 300
            repeat-rate 50
        }

        touchpad {
            tap
            natural-scroll
            accel-speed 0.3
        }

        mouse {
            accel-speed 0.0
        }
    }

    // ===== Output =====
    // External 4K HiDPI monitor
    output "HDMI-A-1" {
        mode "3840x2560@50"
        scale 1.5  // HiDPI scaling for comfortable viewing
        position x=0 y=0
        transform "normal"
        variable-refresh-rate on  // Enable VRR if supported
    }

    // Laptop display - DISABLED (using external only)
    output "eDP-1" {
        off
    }

    // ===== Layout =====
    layout {
        gaps 16  // Larger gaps for better aesthetics
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        // Vibrant focus ring with gradient
        focus-ring {
            width 4  // Thicker for visibility
            active-color "${colorScheme.bright_yellow}"  // Bright yellow
            inactive-color "${colorScheme.bg3}"

            // Gradient effect
            active-gradient {
                from "${colorScheme.bright_yellow}"
                to "${colorScheme.bright_orange}"
                angle 45
            }
        }

        // Vibrant borders
        border {
            width 3
            active-color "${colorScheme.bright_yellow}"
            inactive-color "${colorScheme.bg3}"

            // Gradient for active border
            active-gradient {
                from "${colorScheme.bright_yellow}"
                to "${colorScheme.bright_orange}"
                angle 45
            }
        }

        // Struts (reserved space around screen edges)
        struts {
            left 0
            right 0
            top 0
            bottom 0
        }

        // Window shadows for depth
        shadow {
            on
            blur-sigma 12.0  // Softness/blur radius
            color "#00000080"  // Semi-transparent black
            offset-x 0
            offset-y 4  // Drop shadow effect
            spread 0
        }
    }

    // ===== Workspaces =====
    workspace "1"
    workspace "2"
    workspace "3"
    workspace "4"
    workspace "5"
    workspace "6"
    workspace "7"
    workspace "8"
    workspace "9"

    // ===== Window Rules =====

    // Global window rules - rounded corners and shadows
    window-rule {
        // Apply to all windows
        geometry-corner-radius 12
        clip-to-geometry true

        // Drop shadows
        draw-border-with-background false

        // Prefer server-side decorations for better integration
        prefer-no-csd
    }

    // Firefox - larger default width
    window-rule {
        match app-id="firefox"
        default-column-width { proportion 0.75; }
        geometry-corner-radius 12
        clip-to-geometry true
    }

    // Emacs - coding-friendly width
    window-rule {
        match app-id="emacs"
        default-column-width { proportion 0.66667; }
        geometry-corner-radius 12
        clip-to-geometry true
    }

    // Terminal windows - slightly smaller
    window-rule {
        match app-id="foot"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 12
        clip-to-geometry true
    }

    window-rule {
        match app-id="kitty"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 12
        clip-to-geometry true
    }

    // Floating windows (dialogs, popups)
    window-rule {
        match is-floating=true
        geometry-corner-radius 16
        clip-to-geometry true
    }

    // ===== Keybindings =====
    binds {
        // Mod key (Super/Windows key)
        Mod+Return { spawn "foot"; }
        Mod+Shift+Return { spawn "kitty"; }
        Mod+D { spawn "fuzzel"; }
        Mod+Q { close-window; }

        // Emacs
        Mod+E { spawn "emacsclient" "-c" "-a" "emacs"; }
        Mod+Shift+E { spawn "emacsclient" "-t" "-a" "emacs"; }

        // Org shortcuts (open emacs with org commands)
        Mod+C { spawn "emacsclient" "-c" "-e" "(org-capture)"; }
        Mod+A { spawn "emacsclient" "-c" "-e" "(org-agenda)"; }
        Mod+N { spawn "emacsclient" "-c" "-e" "(org-roam-node-find)"; }

        // Firefox
        Mod+B { spawn "firefox"; }

        // Focus movement (Vim-style)
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Left { focus-column-left; }
        Mod+Down { focus-window-down; }
        Mod+Up { focus-window-up; }
        Mod+Right { focus-column-right; }

        // Move windows (Vim-style)
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Right { move-column-right; }

        // Workspaces
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        // Move to workspace
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Column width
        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        // Monitor focus
        Mod+Comma { focus-monitor-left; }
        Mod+Period { focus-monitor-right; }
        Mod+Shift+Comma { move-column-to-monitor-left; }
        Mod+Shift+Period { move-column-to-monitor-right; }

        // Screenshots
        Print { spawn "grim" "-g" "$(slurp)" "~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"; }
        Mod+Print { spawn "grim" "~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"; }

        // System
        Mod+Shift+Q { quit; }
        Mod+Shift+P { power-off-monitors; }
    }

    // ===== Cursor =====
    // Cursor configuration - using environment variables instead
    // XCURSOR_SIZE and XCURSOR_THEME are set in session variables

    // ===== Hotkey Overlay =====
    hotkey-overlay {
        skip-at-startup
    }

    // ===== Environment =====
    environment {
        // Wayland
        NIXOS_OZONE_WL "1"
        MOZ_ENABLE_WAYLAND "1"
        QT_QPA_PLATFORM "wayland"
        GDK_BACKEND "wayland"

        // Gruvbox colors
        GRUVBOX_BG "${colorScheme.bg}"
        GRUVBOX_FG "${colorScheme.fg}"
    }

    // ===== Animations =====
    animations {
        slowdown 0.7  // Faster for snappier feel

        window-open {
            duration-ms 180
            curve "ease-out-expo"
        }

        window-close {
            duration-ms 120
            curve "ease-in-expo"
        }

        workspace-switch {
            duration-ms 200
            curve "ease-in-out-expo"
        }

        window-movement {
            duration-ms 120
            curve "ease-out-cubic"
        }

        window-resize {
            duration-ms 120
            curve "ease-out-cubic"
        }

        config-notification-open-close {
            off
        }
    }

    // ===== Performance Optimizations =====
    prefer-no-csd

    // ===== Screenshot =====
    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

    // ===== Background (Wallpaper) =====
    // Using swaybg for wallpaper
    spawn-at-startup "swaybg" "-i" "$HOME/Pictures/Wallpapers/gruvbox-current.png" "-m" "fill"

    // ===== Startup =====
    spawn-at-startup "waybar"
    spawn-at-startup "mako"

    // Gamma/Night light
    spawn-at-startup "wlsunset" "-l" "25" "-L" "55"  // Adjust for Dubai
  '';

  # Waybar configuration for niri
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 48;  # Taller for HiDPI
        margin = "10 16 0 16";
        spacing = 10;

        modules-left = [ "custom/niri-workspaces" "custom/niri-window" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "idle_inhibitor" "pulseaudio" "network" "cpu" "memory" "temperature" "battery" ];

        "custom/niri-workspaces" = {
          exec = "niri msg --json workspaces | jq -r '.[] | .name' | tr '\n' ' '";
          interval = 1;
          format = "  {}";
        };

        "custom/niri-window" = {
          exec = "niri msg --json focused-window | jq -r '.title // \"Desktop\"'";
          interval = 1;
          format = "  {}";
          max-length = 50;
        };

        clock = {
          format = "  {:%H:%M   %a %b %d}";
          format-alt = "  {:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "  {usage}%";
          format-alt = "  {avg_frequency} GHz";
          interval = 2;
          tooltip = true;
        };

        memory = {
          format = "  {percentage}%";
          format-alt = "  {used:0.1f}G / {total:0.1f}G";
          interval = 2;
          tooltip-format = "Used: {used:0.2f}GB\nAvailable: {avail:0.2f}GB\nTotal: {total:0.2f}GB";
        };

        temperature = {
          critical-threshold = 80;
          format = " {temperatureC}°C";
          format-critical = " {temperatureC}°C";
          interval = 2;
        };

        battery = {
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
          tooltip-format = "{timeTo}\nPower: {power}W";
        };

        network = {
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "  {ifname}";
          format-disconnected = "  Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}";
          interval = 2;
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "  {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
          tooltip-format = "{desc}\n{volume}%";
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip-format-activated = "Idle inhibitor: Active";
          tooltip-format-deactivated = "Idle inhibitor: Inactive";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 15px;  # Larger for HiDPI
        font-weight: 500;
        border: none;
        border-radius: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
      }

      window#waybar {
        background: transparent;
        color: ${colorScheme.fg};
      }

      /* Module styling with rounded corners and gradients */
      #custom-niri-workspaces,
      #custom-niri-window,
      #clock,
      #cpu,
      #memory,
      #temperature,
      #battery,
      #network,
      #pulseaudio,
      #tray,
      #idle_inhibitor {
        padding: 6px 16px;
        margin: 4px 2px;
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.fg};
        border-radius: 12px;
        border: 2px solid ${colorScheme.bg3};
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
        transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
      }

      /* Hover effects */
      #custom-niri-workspaces:hover,
      #custom-niri-window:hover,
      #clock:hover,
      #cpu:hover,
      #memory:hover,
      #temperature:hover,
      #battery:hover,
      #network:hover,
      #pulseaudio:hover,
      #idle_inhibitor:hover {
        background: linear-gradient(135deg, ${colorScheme.bg2} 0%, ${colorScheme.bg3} 100%);
        border-color: ${colorScheme.bright_yellow};
        box-shadow: 0 4px 12px rgba(250, 189, 47, 0.3);
        transform: translateY(-1px);
      }

      /* Left modules - Workspace indicator with accent */
      #custom-niri-workspaces {
        background: linear-gradient(135deg, ${colorScheme.bright_yellow} 0%, ${colorScheme.yellow} 100%);
        color: ${colorScheme.bg};
        font-weight: bold;
        border-color: ${colorScheme.bright_orange};
      }

      #custom-niri-window {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.bright_blue};
        font-style: italic;
      }

      /* Center - Clock with accent */
      #clock {
        background: linear-gradient(135deg, ${colorScheme.bright_blue} 0%, ${colorScheme.blue} 100%);
        color: ${colorScheme.bg};
        font-weight: bold;
        padding: 6px 20px;
        border-color: ${colorScheme.bright_aqua};
      }

      /* Right modules - System info */
      #cpu {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.bright_green};
      }

      #memory {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.bright_aqua};
      }

      #temperature {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.bright_purple};
      }

      #temperature.critical {
        background: linear-gradient(135deg, ${colorScheme.bright_red} 0%, ${colorScheme.red} 100%);
        color: ${colorScheme.bg};
        border-color: ${colorScheme.bright_orange};
        animation: blink 1s linear infinite;
      }

      #battery {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.bright_yellow};
      }

      #battery.charging {
        background: linear-gradient(135deg, ${colorScheme.bright_green} 0%, ${colorScheme.green} 100%);
        color: ${colorScheme.bg};
      }

      #battery.warning:not(.charging) {
        background: linear-gradient(135deg, ${colorScheme.bright_orange} 0%, ${colorScheme.orange} 100%);
        color: ${colorScheme.bg};
        animation: blink 2s linear infinite;
      }

      #battery.critical:not(.charging) {
        background: linear-gradient(135deg, ${colorScheme.bright_red} 0%, ${colorScheme.red} 100%);
        color: ${colorScheme.bg};
        border-color: ${colorScheme.bright_orange};
        animation: blink 1s linear infinite;
      }

      #network {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.bright_blue};
      }

      #network.disconnected {
        background: linear-gradient(135deg, ${colorScheme.dim_red} 0%, ${colorScheme.red} 100%);
        color: ${colorScheme.fg};
      }

      #pulseaudio {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.bright_purple};
      }

      #pulseaudio.muted {
        background: linear-gradient(135deg, ${colorScheme.bg2} 0%, ${colorScheme.bg3} 100%);
        color: ${colorScheme.gray};
      }

      #tray {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        padding: 6px 12px;
      }

      #tray > .passive {
        opacity: 0.7;
      }

      #tray > .needs-attention {
        background-color: ${colorScheme.bright_red};
        border-radius: 8px;
        animation: blink 1s linear infinite;
      }

      #idle_inhibitor {
        background: linear-gradient(135deg, ${colorScheme.bg1} 0%, ${colorScheme.bg2} 100%);
        color: ${colorScheme.fg4};
      }

      #idle_inhibitor.activated {
        background: linear-gradient(135deg, ${colorScheme.bright_orange} 0%, ${colorScheme.orange} 100%);
        color: ${colorScheme.bg};
        border-color: ${colorScheme.bright_yellow};
      }

      /* Blink animation for critical states */
      @keyframes blink {
        0%, 49% {
          opacity: 1.0;
        }
        50%, 100% {
          opacity: 0.7;
        }
      }

      /* Tooltip styling */
      tooltip {
        background: ${colorScheme.bg};
        border: 2px solid ${colorScheme.bright_yellow};
        border-radius: 12px;
        padding: 8px 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
      }

      tooltip label {
        color: ${colorScheme.fg};
        font-family: "JetBrainsMono Nerd Font";
      }
    '';
  };

  # Mako notification daemon
  services.mako = {
    enable = true;
    settings = {
      background-color = colorScheme.bg;
      text-color = colorScheme.fg;
      border-color = colorScheme.yellow;
      border-size = 2;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
    };
  };

  # Additional Wayland tools and eye candy
  home.packages = with pkgs; [
    # Screenshots and screen tools
    grim       # Screenshot
    slurp      # Screen area selection
    swappy     # Screenshot editor
    wl-clipboard

    # Wallpaper
    swaybg     # Background/wallpaper daemon
    mpvpaper   # Video wallpapers (optional)

    # Color/gamma control
    wlsunset  # Day/night gamma adjustment
    wl-gammarelay-rs  # Manual gamma control

    # Screen recording
    wf-recorder  # Wayland screen recorder

    # Debug tools
    wev        # Wayland event viewer

    # Notifications enhancement
    libnotify  # Desktop notifications
  ];
}
