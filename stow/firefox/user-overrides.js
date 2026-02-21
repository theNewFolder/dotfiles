// === User Overrides for Betterfox ===
// Void Linux T490 i5-8365U Intel UHD 620

// --- VA-API GPU video decode ---
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.ffvpx.enabled", false);
user_pref("media.hardware-video-decoding.enabled", true);
user_pref("media.hardware-video-decoding.force-enabled", true);
user_pref("media.ffmpeg.dmabuf-textures.enabled", true);

// --- WebRender GPU compositor ---
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.software", false);

// --- userChrome.css support ---
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);

// --- UI density: compact ---
user_pref("browser.uidensity", 1);

// --- Privacy (match qutebrowser) ---
user_pref("network.http.referer.XOriginPolicy", 2);
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);
user_pref("network.cookie.cookieBehavior", 1);
user_pref("dom.security.https_only_mode", true);
user_pref("privacy.globalprivacycontrol.enabled", true);
user_pref("content.notify.interval", 100000);

// --- Dark mode ---
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("browser.in-content.dark-mode", true);
user_pref("layout.css.prefers-color-scheme.content-override", 0);

// --- Disable junk ---
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.ml.enable", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);

// --- Performance ---
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.enable", true);
user_pref("browser.cache.memory.capacity", 262144);
user_pref("browser.sessionstore.interval", 600000);
user_pref("image.mem.min_discard_timeout_ms", 2100000000);

// --- Startpage ---
user_pref("browser.startup.homepage", "file:///home/dev/dotfiles/stow/qutebrowser/.config/qutebrowser/startpage/index.html");
user_pref("browser.startup.page", 1);

// --- Search ---
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest", false);

// --- Scrolling ---
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("mousewheel.default.delta_multiplier_y", 300);

// --- Misc ---
user_pref("full-screen-api.warning.timeout", 0);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.quitShortcut.disabled", true);
