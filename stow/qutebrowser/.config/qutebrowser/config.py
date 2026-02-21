import os
config.load_autoconfig(False)
config.source('gruvbox.py')

# ── Fonts ───────────────────────────────────────────────────────
c.fonts.default_family = ['DankMono Nerd Font', 'monospace']
c.fonts.default_size = '12pt'
c.fonts.hints = 'bold 13px default_family'
c.fonts.web.family.fixed = 'DankMono Nerd Font Mono'
c.fonts.web.size.default = 16

# ── Chrome (hide until needed) ─────────────────────────────────
c.tabs.show = 'switching'
c.tabs.position = 'top'
c.tabs.title.format = '{audio}{index}: {current_title}'
c.tabs.last_close = 'close'
c.tabs.background = True
c.tabs.select_on_remove = 'prev'
c.tabs.padding = {'bottom': 2, 'left': 5, 'right': 5, 'top': 2}
c.tabs.indicator.width = 0
c.statusbar.show = 'in-mode'
c.scrolling.bar = 'never'

# ── URL & Search ────────────────────────────────────────────────
startpage = f'file://{os.path.expanduser("~/.config/qutebrowser/startpage/index.html")}'
c.url.start_pages = [startpage]
c.url.default_page = startpage
c.url.open_base_url = True
c.url.searchengines = {
    'DEFAULT': 'https://www.perplexity.ai/search?q={}',
    'g':  'https://www.google.com/search?q={}',
    'dd': 'https://duckduckgo.com/?q={}',
    'gh': 'https://github.com/search?q={}',
    'aw': 'https://wiki.archlinux.org/?search={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'wp': 'https://en.wikipedia.org/w/index.php?search={}',
    'vw': 'https://man.voidlinux.org/?q={}',
    'pkg': 'https://voidlinux.org/packages/?q={}',
}

# ── Productivity ────────────────────────────────────────────────
c.auto_save.session = True
c.session.lazy_restore = True
c.completion.height = '30%'
c.completion.shrink = True
c.completion.scrollbar.width = 0
c.downloads.location.directory = '~/Downloads'
c.downloads.location.prompt = False
c.downloads.remove_finished = 5000
c.scrolling.smooth = False
c.content.autoplay = False
c.content.pdfjs = False
c.content.notifications.enabled = False
c.confirm_quit = ['multiple-tabs']
c.hints.chars = 'asdfghjkl'

# ── Editor (emacsclient default) ───────────────────────────────
c.editor.command = ['emacsclient', '-c', '+{line}:{column0}', '{file}']

# ── Ad Blocking ─────────────────────────────────────────────────
c.content.blocking.enabled = True
c.content.blocking.method = 'both'
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
]
c.content.blocking.hosts.lists = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts',
]

# ── Privacy ─────────────────────────────────────────────────────
c.content.headers.do_not_track = True
c.content.headers.referer = 'same-domain'
c.content.headers.accept_language = 'en-US,en;q=0.5'
c.content.canvas_reading = False
c.content.webgl = False
c.content.webrtc_ip_handling_policy = 'disable-non-proxied-udp'
c.content.cookies.accept = 'no-3rdparty'
c.content.dns_prefetch = False
c.content.geolocation = False

# ── Dark Mode ───────────────────────────────────────────────────
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.page = 'smart'
c.colors.webpage.darkmode.policy.images = 'never'
c.colors.webpage.bg = '#0d0e0f'
c.colors.webpage.preferred_color_scheme = 'dark'

# ── Keybindings ─────────────────────────────────────────────────
config.bind(',m', 'spawn -d mpv --force-window=immediate {url}')
config.bind(',M', 'hint links spawn -d mpv --force-window=immediate {hint-url}')
config.bind(';M', 'hint --rapid links spawn -d mpv --force-window=immediate {hint-url}')
config.bind(',d', 'config-cycle colors.webpage.darkmode.enabled true false ;; restart')
config.bind(',e', 'spawn kitty -e nvim {url}')
config.bind(',p', 'spawn --userscript qute-pass')
config.bind(',P', 'spawn --userscript qute-pass --password-only')
config.bind(',c', 'spawn --userscript org-capture')
config.bind(',C', 'spawn --userscript org-capture W')
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('xx', 'config-cycle tabs.show always never')
config.bind('xb', 'config-cycle statusbar.show always in-mode')

# ── Reddit redirect ─────────────────────────────────────────────
import qutebrowser.api.interceptor
def _rewrite(request):
    url = request.request_url
    if url.host() == 'www.reddit.com':
        url.setHost('old.reddit.com')
        request.redirect(url)
qutebrowser.api.interceptor.register(_rewrite)
