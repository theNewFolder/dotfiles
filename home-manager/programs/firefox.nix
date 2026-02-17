# Firefox browser configuration

{ config, pkgs, colorScheme, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.dev = {
      id = 0;
      isDefault = true;

      settings = {
        # Performance
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true;
        "browser.sessionstore.interval" = 15000000;

        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.send_pings" = false;
        "beacon.enabled" = false;

        # UI
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.tabs.tabMinWidth" = 50;
        "browser.uidensity" = 1;  # Compact mode
        "browser.tabs.inTitlebar" = 1;

        # Smooth scrolling
        "general.smoothScroll" = true;
        "mousewheel.default.delta_multiplier_y" = 80;

        # New tab page
        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3;  # Restore previous session

        # Search
        "browser.urlbar.suggest.searches" = true;
        "browser.search.suggest.enabled" = true;
      };

      # Extensions - Note: NUR is required for firefox-addons
      # Add to your flake.nix:
      # nur.url = "github:nix-community/NUR";
      #
      # For now, we'll comment this out and you can install extensions manually
      # or add NUR to your flake
      #
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   ublock-origin
      #   bitwarden
      #   vimium
      # ];

      userChrome = ''
        /* Minimal Firefox - Gruvbox Dark */

        /* Hide tab bar (use Tree Style Tab extension instead if desired) */
        /* Uncomment if you want to hide tabs completely */
        /* #TabsToolbar { visibility: collapse !important; } */

        /* Compact tabs */
        .tabbrowser-tab {
          min-height: 30px !important;
        }

        /* Gruvbox colors for URL bar */
        #urlbar {
          background-color: ${colorScheme.bg1} !important;
          color: ${colorScheme.fg} !important;
          border: 1px solid ${colorScheme.bg2} !important;
        }

        #urlbar-input {
          color: ${colorScheme.fg} !important;
        }

        /* Gruvbox colors for search bar */
        #searchbar {
          background-color: ${colorScheme.bg1} !important;
          color: ${colorScheme.fg} !important;
        }

        /* Hide sidebar header */
        #sidebar-header {
          display: none !important;
        }
      '';

      userContent = ''
        /* Dark theme for web content */
        @-moz-document url-prefix(about:) {
          * {
            background-color: ${colorScheme.bg} !important;
            color: ${colorScheme.fg} !important;
          }
        }
      '';
    };
  };

  # Set Firefox as default browser
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
