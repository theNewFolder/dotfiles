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
        gaps 20  // Generous gaps for eye candy
        center-focused-column "on-overflow"  // Center when space available

        // More flexible preset widths
        preset-column-widths {
            proportion 0.25    // Quarter screen
            proportion 0.33333 // Third
            proportion 0.5     // Half
            proportion 0.66667 // Two thirds
            proportion 0.75    // Three quarters
        }

        default-column-width { proportion 0.5; }

        // Ultra-vibrant focus ring with animated gradient
        focus-ring {
            width 5  // Extra thick for maximum visibility
            active-color "${colorScheme.bright_yellow}"
            inactive-color "${colorScheme.bg2}"

            // Multi-color gradient for eye candy
            active-gradient {
                from "${colorScheme.bright_yellow}"
                to "${colorScheme.bright_orange}"
                angle 90
                relative-to "window"
            }
        }

        // Enhanced borders with glow effect
        border {
            width 4
            active-color "${colorScheme.bright_yellow}"
            inactive-color "${colorScheme.bg3}"

            // Dynamic gradient
            active-gradient {
                from "${colorScheme.bright_aqua}"
                via "${colorScheme.bright_yellow}"
                to "${colorScheme.bright_orange}"
                angle 135
                relative-to "workspace-view"
            }
        }

        // Struts for waybar/panels
        struts {
            left 0
            right 0
            top 48  // Reserve space for waybar
            bottom 0
        }

        // Enhanced shadows for maximum depth
        shadow {
            on
            blur-sigma 20.0  // Larger blur for softer shadows
            color "#00000099"  // Darker shadow
            offset-x 0
            offset-y 8  // Deeper drop shadow
            spread -4  // Negative spread for tighter shadow
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

    // Global defaults - maximum eye candy
    window-rule {
        geometry-corner-radius 16  // Extra rounded
        clip-to-geometry true
        draw-border-with-background false
        prefer-no-csd

        // Subtle opacity for unfocused windows
        opacity 0.98
    }

    // ===== Browsers =====
    window-rule {
        match app-id="firefox"
        default-column-width { proportion 0.75; }
        geometry-corner-radius 16
        open-on-workspace 2  // Browsers on workspace 2
    }

    window-rule {
        match app-id="chromium"
        default-column-width { proportion 0.75; }
        geometry-corner-radius 16
        open-on-workspace 2
    }

    // ===== Editors & IDEs =====
    window-rule {
        match app-id="emacs"
        default-column-width { proportion 0.66667; }
        geometry-corner-radius 16
        open-on-workspace 1  // Coding on workspace 1
        opacity 1.0  // Full opacity for text editing
    }

    window-rule {
        match app-id="code"
        default-column-width { proportion 0.75; }
        geometry-corner-radius 16
        open-on-workspace 1
    }

    window-rule {
        match app-id="neovide"
        default-column-width { proportion 0.66667; }
        geometry-corner-radius 16
        open-on-workspace 1
    }

    // ===== Terminals =====
    window-rule {
        match app-id="foot"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
        opacity 0.95  // Slight transparency for style
    }

    window-rule {
        match app-id="kitty"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
        opacity 0.95
    }

    window-rule {
        match app-id="wezterm"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
        opacity 0.95
    }

    window-rule {
        match app-id="Alacritty"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
        opacity 0.95
    }

    // ===== File Managers =====
    window-rule {
        match app-id="org.gnome.Nautilus"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
    }

    window-rule {
        match app-id="thunar"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
    }

    window-rule {
        match app-id="pcmanfm"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
    }

    // ===== Media Players =====
    window-rule {
        match app-id="mpv"
        default-column-width { proportion 0.66667; }
        geometry-corner-radius 20  // Extra rounded for media
        open-on-workspace 4  // Media on workspace 4
        block-out-from "screen-capture"  // Privacy for media
    }

    window-rule {
        match app-id="vlc"
        default-column-width { proportion 0.66667; }
        geometry-corner-radius 20
        open-on-workspace 4
    }

    // ===== Communication =====
    window-rule {
        match app-id="discord"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
        open-on-workspace 3  // Chat on workspace 3
    }

    window-rule {
        match app-id="slack"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
        open-on-workspace 3
    }

    window-rule {
        match app-id="Element"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
        open-on-workspace 3
    }

    // ===== System Tools =====
    window-rule {
        match app-id="bluetuith"
        default-column-width { proportion 0.33333; }
        geometry-corner-radius 16
    }

    window-rule {
        match app-id="pavucontrol"
        default-column-width { proportion 0.33333; }
        geometry-corner-radius 16
    }

    window-rule {
        match app-id="btop"
        default-column-width { proportion 0.5; }
        geometry-corner-radius 16
    }

    // ===== Floating Windows =====
    window-rule {
        match is-floating=true
        geometry-corner-radius 20  // Extra rounded for popups
        clip-to-geometry true
    }

    // Dialogs and transient windows
    window-rule {
        match is-dialog=true
        geometry-corner-radius 20
        default-column-width { proportion 0.33333; }
    }

    // Picture-in-picture
    window-rule {
        match title="Picture-in-Picture"
        geometry-corner-radius 24
        min-width 400
        min-height 300
    }

    // ===== Keybindings =====
    binds {
        // ===== Application Launchers =====
        Mod+Return { spawn "foot"; }  // Primary terminal
        Mod+Shift+Return { spawn "kitty"; }  // Alt terminal
        Mod+D { spawn "fuzzel"; }  // App launcher
        Mod+Space { spawn "fuzzel"; }  // Alt app launcher
        Mod+Q { close-window; }  // Close window

        // ===== Quick Launch Apps =====
        Mod+B { spawn "firefox"; }  // Browser
        Mod+E { spawn "emacsclient" "-c" "-a" "emacs"; }  // Emacs GUI
        Mod+Shift+E { spawn "emacsclient" "-t" "-a" "emacs"; }  // Emacs terminal
        Mod+T { spawn "thunar"; }  // File manager
        Mod+M { spawn "foot" "-e" "btop"; }  // System monitor

        // ===== Emacs Org-mode Integration =====
        Mod+C { spawn "emacsclient" "-c" "-e" "(org-capture)"; }  // Quick capture
        Mod+A { spawn "emacsclient" "-c" "-e" "(org-agenda)"; }  // Agenda
        Mod+N { spawn "emacsclient" "-c" "-e" "(org-roam-node-find)"; }  // Org-roam
        Mod+Shift+N { spawn "emacsclient" "-c" "-e" "(org-roam-dailies-capture-today)"; }  // Daily note

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

        // ===== Screenshots & Screen Recording =====
        Print { spawn "grim" "-g" "$(slurp)" "~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"; }  // Area
        Mod+Print { spawn "grim" "~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"; }  // Full screen
        Shift+Print { spawn "grim" "-g" "$(slurp)" "-" "|" "swappy" "-f" "-"; }  // Area + edit
        Ctrl+Print { spawn "grim" "-g" "$(slurp)" "-" "|" "wl-copy"; }  // Area to clipboard
        Mod+Shift+Print { spawn "grim" "-" "|" "wl-copy"; }  // Full to clipboard

        // Screen recording
        Mod+Ctrl+R { spawn "wf-recorder" "-g" "$(slurp)" "-f" "~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4"; }

        // ===== Audio Controls =====
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        // Alt audio controls (for keyboards without media keys)
        Mod+Plus { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        Mod+Minus { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        Mod+0 { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }

        // Media player controls
        XF86AudioPlay { spawn "playerctl" "play-pause"; }
        XF86AudioPause { spawn "playerctl" "pause"; }
        XF86AudioNext { spawn "playerctl" "next"; }
        XF86AudioPrev { spawn "playerctl" "previous"; }
        Mod+P { spawn "playerctl" "play-pause"; }  // Alt media control

        // ===== Brightness Controls =====
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "10%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "10%-"; }
        Mod+BracketRight { spawn "brightnessctl" "set" "10%+"; }  // Alt brightness
        Mod+BracketLeft { spawn "brightnessctl" "set" "10%-"; }

        // ===== Quick Utilities =====
        Mod+V { spawn "cliphist" "list" "|" "fuzzel" "-d" "|" "cliphist" "decode" "|" "wl-copy"; }  // Clipboard history
        Mod+Shift+V { spawn "foot" "-e" "bluetuith"; }  // Bluetooth manager
        Mod+X { spawn "fuzzel" "-d"; }  // Alt launcher
        Mod+Shift+D { spawn "wdisplays"; }  // Display settings
        Mod+Shift+A { spawn "pavucontrol"; }  // Audio settings

        // ===== Window Management Enhancements =====
        Mod+Tab { focus-column-right; }  // Quick window switch
        Mod+Shift+Tab { focus-column-left; }  // Reverse switch
        Mod+Grave { focus-workspace-previous; }  // Previous workspace
        Mod+Shift+Grave { move-column-to-workspace-previous; }  // Move to previous WS

        // Consume window (remove from layout)
        Mod+Ctrl+H { consume-or-expel-window-left; }
        Mod+Ctrl+L { consume-or-expel-window-right; }

        // Center column
        Mod+Shift+C { center-column; }

        // ===== System Controls =====
        Mod+Shift+Q { quit; }  // Quit niri
        Mod+Shift+P { power-off-monitors; }  // Power off monitors
        Mod+Shift+R { spawn "niri" "msg" "reload-config"; }  // Reload config
        Mod+Escape { spawn "niri" "msg" "reload-config"; }  // Alt reload

        // Lock screen (assuming swaylock)
        Mod+Shift+L { spawn "swaylock"; }

        // Power menu (custom script or rofi/fuzzel based)
        Mod+Shift+Escape { spawn "fuzzel-power-menu"; }
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

    // ===== Animations - Maximum Eye Candy =====
    animations {
        // Slower = more eye candy, faster = snappier
        slowdown 1.0  // Balanced for smooth visuals

        // Window opening - spring effect for bounce
        window-open {
            duration-ms 250
            curve "ease-out-back"  // Overshoot for bounce effect
        }

        // Window closing - quick fade
        window-close {
            duration-ms 180
            curve "ease-in-cubic"
        }

        // Workspace switching - smooth glide
        workspace-switch {
            duration-ms 280
            curve "ease-in-out-cubic"
        }

        // Window movement - physics-based
        window-movement {
            duration-ms 200
            curve "ease-out-expo"
        }

        // Window resize - smooth elastic
        window-resize {
            duration-ms 200
            curve "ease-out-cubic"
        }

        // Horizontal view movement (scrolling workspaces)
        horizontal-view-movement {
            duration-ms 300
            curve "ease-in-out-cubic"
        }

        // Window focus change
        window-focus-change {
            duration-ms 150
            curve "ease-out-quad"
        }

        // Config notifications
        config-notification-open-close {
            duration-ms 200
            curve "ease-out-cubic"
        }
    }

    // ===== Performance Optimizations =====
    prefer-no-csd

    // Render settings for best quality
    // (Note: These may not be available in all niri versions)

    // ===== Screenshot =====
    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

    // ===== Background (Wallpaper) =====
    // Using swaybg for wallpaper with smooth transitions
    spawn-at-startup "swaybg" "-i" "$HOME/Pictures/Wallpapers/gruvbox-current.png" "-m" "fill"

    // ===== Startup Applications =====
    // Status bar
    spawn-at-startup "waybar"

    // Notifications
    spawn-at-startup "mako"

    // Clipboard manager (for Mod+V)
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"

    // Gamma/Night light (Dubai coordinates)
    spawn-at-startup "wlsunset" "-l" "25" "-L" "55"

    // Idle management (lock after 10 min, screen off after 15)
    spawn-at-startup "swayidle" "-w" "timeout" "600" "swaylock" "timeout" "900" "niri" "msg" "action" "power-off-monitors"

    // Authentication agent for GUI apps
    spawn-at-startup "/usr/libexec/polkit-gnome-authentication-agent-1"

    // Network manager applet
    spawn-at-startup "nm-applet" "--indicator"
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
