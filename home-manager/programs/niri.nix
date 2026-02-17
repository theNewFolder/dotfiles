# Niri Wayland compositor configuration

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
    output "HDMI-A-1" {
        mode "3840x2560@50"
        scale 1.0
        position x=0 y=0
    }

    output "eDP-1" {
        mode "1920x1080@144"
        scale 1.0
        position x=3840 y=0
    }

    // ===== Layout =====
    layout {
        gaps 8
        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 2
            active-color "${colorScheme.yellow}"
            inactive-color "${colorScheme.bg2}"
        }

        border {
            width 2
            active-color "${colorScheme.yellow}"
            inactive-color "${colorScheme.bg2}"
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
    window-rule {
        match app-id="firefox"
        default-column-width { proportion 0.75; }
    }

    window-rule {
        match app-id="emacs"
        default-column-width { proportion 0.66667; }
    }

    // ===== Keybindings =====
    binds {
        // Mod key (Super/Windows key)
        Mod+Return { spawn "wezterm"; }
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
    cursor {
        size 24
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
        slowdown 1.0

        window-open {
            duration-ms 150
        }

        window-close {
            duration-ms 150
        }

        workspace-switch {
            duration-ms 200
        }
    }

    // ===== Screenshot =====
    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

    // ===== Startup =====
    spawn-at-startup "waybar"
    spawn-at-startup "mako"
  '';

  # Waybar configuration for niri
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [ "custom/niri-workspaces" "custom/niri-window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "battery" ];

        clock = {
          format = "{:%H:%M   %Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        cpu = {
          format = "  {usage}%";
          tooltip = false;
        };

        memory = {
          format = "  {}%";
        };

        temperature = {
          critical-threshold = 80;
          format = " {temperatureC}°C";
        };

        battery = {
          format = "{icon}  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          states = {
            warning = 30;
            critical = 15;
          };
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ifname}";
          format-disconnected = "⚠  Disconnected";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "  Muted";
          format-icons = {
            default = [ "" "" "" ];
          };
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: ${colorScheme.bg};
        color: ${colorScheme.fg};
      }

      #custom-niri-workspaces, #custom-niri-window,
      #clock, #cpu, #memory, #temperature, #battery, #network, #pulseaudio {
        padding: 0 10px;
        background-color: ${colorScheme.bg1};
        color: ${colorScheme.fg};
        margin: 2px 2px;
      }

      #battery.warning {
        color: ${colorScheme.yellow};
      }

      #battery.critical {
        color: ${colorScheme.red};
      }

      #temperature.critical {
        color: ${colorScheme.red};
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

  # Additional Wayland tools
  home.packages = with pkgs; [
    grim       # Screenshot
    slurp      # Screen area selection
    wl-clipboard
    wev        # Wayland event viewer (for debugging)
  ];
}
