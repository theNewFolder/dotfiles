# Firefox browser configuration

{ config, pkgs, colorScheme, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.dev = {
      id = 0;
      isDefault = true;

      settings = {
        # ===== Performance & Speed =====
        "browser.cache.disk.enable" = false;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 524288;  # 512MB cache
        "browser.sessionstore.interval" = 15000000;

        # Hardware acceleration (NVIDIA + Wayland)
        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.av1.enabled" = true;
        "gfx.canvas.accelerated" = true;

        # Network performance
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.pipelining" = true;
        "network.http.proxy.pipelining" = true;
        "network.dns.disablePrefetch" = false;
        "network.prefetch-next" = true;

        # ===== Privacy & Security (Betterfox/Arkenfox inspired) =====

        # Enhanced Tracking Protection
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.donottrackheader.enabled" = true;

        # Disable telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Disable studies and experiments
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        # Disable safe browsing (privacy concern, sends URLs to Google)
        # Note: This reduces security, only disable if you know what you're doing
        # "browser.safebrowsing.malware.enabled" = false;
        # "browser.safebrowsing.phishing.enabled" = false;

        # Disable beacons and pings
        "browser.send_pings" = false;
        "beacon.enabled" = false;

        # Fingerprinting protection
        "privacy.resistFingerprinting" = false;  # Can break some sites
        "privacy.firstparty.isolate" = false;  # Can break some sites
        "webgl.disabled" = false;  # Keep enabled for performance, disable if privacy is critical

        # HTTPS-only mode
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # DNS over HTTPS
        "network.trr.mode" = 2;  # 2 = prefer DoH, fallback to system DNS
        "network.trr.uri" = "https://dns.quad9.net/dns-query";

        # Cookies and site data
        "network.cookie.cookieBehavior" = 1;  # Block third-party cookies
        "privacy.purge_trackers.enabled" = true;

        # Disable autofill (privacy)
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # Disable pocket
        "extensions.pocket.enabled" = false;

        # ===== UI & UX =====
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.tabs.tabMinWidth" = 50;
        "browser.uidensity" = 1;  # Compact mode
        "browser.tabs.inTitlebar" = 1;

        # Smooth scrolling
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "mousewheel.default.delta_multiplier_y" = 80;
        "mousewheel.system_scroll_override.enabled" = true;

        # Animations
        "browser.tabs.animate" = true;
        "browser.fullscreen.animate" = true;
        "ui.prefersReducedMotion" = 0;

        # New tab page
        "browser.newtabpage.enabled" = false;
        "browser.startup.page" = 3;  # Restore previous session
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

        # Search
        "browser.urlbar.suggest.searches" = true;
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

        # ===== Font Rendering =====
        "gfx.font_rendering.cleartype_params.rendering_mode" = 5;
        "gfx.font_rendering.cleartype_params.cleartype_level" = 100;
        "gfx.font_rendering.cleartype_params.force_gdi_classic_for_families" = "";
        "gfx.font_rendering.cleartype_params.force_gdi_classic_max_size" = 15;
        "gfx.font_rendering.directwrite.use_gdi_table_loading" = false;

        # ===== Experimental Features =====
        "layout.css.backdrop-filter.enabled" = true;
        "svg.context-properties.content.enabled" = true;
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
