/* theNewFolder dwm config — Gruvbox Baby Ultra-Dark + DankMono + dwmblocks
 * Hardware: ThinkPad T490 — i5-8365U, Intel UHD 620
 * Latest-compatible patch set:
 * vanitygaps, pertag, autostart,
 * hide_vacant_tags, actualfullscreen, movestack
 */
#include <X11/XF86keysym.h>

/* ── Gruvbox Baby Ultra-Dark palette ─────────────────────────── */
static const char gruvbg[]       = "#0d0e0f";   /* near-black primary bg */
static const char gruvbg1[]      = "#141617";   /* elevated surfaces */
static const char gruvbg2[]      = "#1d2021";   /* selected items */
static const char gruvbg3[]      = "#282828";   /* inactive elements */
static const char gruvbg4[]      = "#3c3836";   /* active borders */
static const char gruvfg[]       = "#ebdbb2";   /* primary text */
static const char gruvfg4[]      = "#a89984";   /* secondary/inactive text */
static const char gruvfgbright[] = "#fbf1c7";   /* emphasized text */
static const char gruvgray[]     = "#928374";   /* comments, separators */
static const char gruvred[]      = "#cc241d";
static const char gruvred1[]     = "#fb4934";
static const char gruvgreen[]    = "#98971a";
static const char gruvgreen1[]   = "#b8bb26";
static const char gruvyellow[]   = "#d79921";
static const char gruvyellow1[]  = "#fabd2f";
static const char gruvblue[]     = "#458588";
static const char gruvblue1[]    = "#83a598";
static const char gruvpurple[]   = "#b16286";
static const char gruvpurple1[]  = "#d3869b";
static const char gruvaqua[]     = "#689d6a";
static const char gruvaqua1[]    = "#8ec07c";
static const char gruvorange[]   = "#d65d0e";
static const char gruvorange1[]  = "#fe8019";

/* ── Appearance ───────────────────────────────────────────────── */
static const unsigned int borderpx       = 2;   /* border pixel of windows */
static const unsigned int snap           = 32;  /* snap pixel */
static const int showbar                 = 1;   /* 0 = no bar */
static const int topbar                  = 1;   /* 0 = bottom bar */
static const int sidepad                 = 14;  /* horizontal bar padding */
static const int vertpad                 = 10;  /* vertical bar padding */
static const int refreshrate             = 60;  /* used by pointer motion throttling */

/* vanitygaps */
static const unsigned int gappih        = 8;   /* horiz inner gap */
static const unsigned int gappiv        = 8;   /* vert inner gap */
static const unsigned int gappoh        = 8;   /* horiz outer gap */
static const unsigned int gappov        = 8;   /* vert outer gap */
static const int smartgaps              = 1;   /* no outer gap with 1 window */
#define FORCE_VSPLIT 1

/* ── Font ────────────────────────────────────────────────────── */
static const char *fonts[] = {
    "DankMono Nerd Font:size=24:antialias=true:autohint=false"
};
static const char dmenufont[] = "DankMono Nerd Font:size=24:antialias=true:autohint=false";

/* ── Alpha (requires alpha patch + picom) ────────────────────── */
static unsigned int baralpha        = 0xcc;
static unsigned int borderalpha     = OPAQUE;

/* ── Colors ───────────────────────────────────────────────────── */
static const char *colors[][3] = {
    /*                  fg           bg          border      */
    [SchemeNorm]  = { gruvfg4,     gruvbg,     gruvbg3     },
    [SchemeSel]   = { gruvfg,      gruvbg,     gruvorange1 },
};

/* ── Tags ─────────────────────────────────────────────────────── */
static const char *tags[] = { "󰆍", "󰈹", "󰘧", "󰉋", "󰙯", "󰕧", "󰎈", "󰒓", "󰇮" };

/* ── Rules ────────────────────────────────────────────────────── */
static const Rule rules[] = {
    /* xprop: WM_CLASS(STRING) = instance, class */
    /* class            instance    title      tags   float monitor */
    { "firefox",        NULL,       NULL,      1<<1,  0,    -1 },
    { "Firefox",        NULL,       NULL,      1<<1,  0,    -1 },
    { "zen-browser",    NULL,       NULL,      1<<1,  0,    -1 },
    { "Emacs",          NULL,       NULL,      1<<2,  0,    -1 },
    { "kitty",          NULL,       NULL,      0,     0,    -1 },
    { "st",             NULL,       "yazi",    1<<3,  0,    -1 },
    { "st",             NULL,       "ncmpcpp", 1<<6,  0,    -1 },
    { NULL,             "spterm",   NULL,      0,     1,    -1 },
    { "discord",        NULL,       NULL,      1<<4,  0,    -1 },
    { "mpv",            NULL,       NULL,      1<<5,  0,    -1 },
    { NULL,             NULL, "Event Tester",  0,     0,    -1 },
};

/* patch-provided helpers must be included before layouts/keys use them */
#include "vanitygaps.c"
#include "movestack.c"

/* ── Layouts ──────────────────────────────────────────────────── */
static const float mfact        = 0.55; /* master area factor */
static const int nmaster        = 1;    /* windows in master */
static const int resizehints    = 0;    /* 0: ignore size hints → no gaps */
static const int lockfullscreen = 1;

static const Layout layouts[] = {
    { "[]=",  tile                   }, /* tile */
    { "><>",  NULL                   }, /* floating */
    { ">M>",  centeredfloatingmaster }, /* selected LARBS-style center float */
};

/* ── Modifier key: Super (Win) ────────────────────────────────── */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG) \
    { MODKEY,                       KEY, view,       {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY, toggleview, {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY, tag,        {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY, toggletag,  {.ui = 1 << TAG} },

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define STATUSBAR "dwmblocks"

/* ── Commands ─────────────────────────────────────────────────── */
static char dmenumon[2] = "0";
static const char *dmenucmd[] = {
    "dmenu_run", "-m", dmenumon, "-fn", dmenufont,
    "-nb", gruvbg, "-nf", gruvfg4,
    "-sb", gruvbg1, "-sf", gruvfg,
    NULL
};
static const char *termcmd[]    = { "kitty", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "kitty", "--title", scratchpadname, "-o", "initial_window_width=100c", "-o", "initial_window_height=30c", NULL };
static const char *browsercmd[] = { "firefox", NULL };
static const char *mixercmd[]   = { "kitty", "-e", "pulsemixer", NULL };
static const char *emacscmd[]   = { "emacsclient", "-c", "-a", "emacs", NULL };
static const char *rangercmd[]  = { "kitty", "-e", "yazi", NULL };
static const char *lockcmd[]    = { "slock", NULL };
static const char *sysactcmd[]  = { "sysact", NULL };
static const char *scrotcmd[]   = { "scrot", "-s", "/tmp/shot_%Y%m%d_%H%M%S.png", NULL };

/* volume (wpctl/pipewire) + signal dwmblocks (10 + 34 = 44) */
static const char *volupcmd[] = {
    "sh", "-c",
    "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+; kill -44 $(pidof dwmblocks) 2>/dev/null || true",
    NULL
};
static const char *voldncmd[] = {
    "sh", "-c",
    "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; kill -44 $(pidof dwmblocks) 2>/dev/null || true",
    NULL
};
static const char *mutecmd[] = {
    "sh", "-c",
    "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; kill -44 $(pidof dwmblocks) 2>/dev/null || true",
    NULL
};

/* brightness (brightnessctl) */
static const char *britupcmd[] = { "brightnessctl", "set", "5%+", NULL };
static const char *britdncmd[] = { "brightnessctl", "set", "5%-", NULL };

/* mpd / mpc */
static const char *mpctoggle[] = { "mpc", "toggle", NULL };
static const char *mpcnext[]   = { "mpc", "next",   NULL };
static const char *mpcprev[]   = { "mpc", "prev",   NULL };

static void
shiftview(const Arg *arg)
{
    const unsigned int n = LENGTH(tags);
    const unsigned int mask = (1U << n) - 1U;
    unsigned int current = selmon->tagset[selmon->seltags] & mask;
    int dist;
    Arg shifted;

    if (!current)
        current = 1U;

    dist = arg->i % (int)n;
    if (dist < 0)
        dist += (int)n;
    if (dist == 0)
        return;

    current = ((current << dist) | (current >> (n - dist))) & mask;
    shifted.ui = current;
    view(&shifted);
}

static void
shifttag(const Arg *arg)
{
    const unsigned int n = LENGTH(tags);
    const unsigned int mask = (1U << n) - 1U;
    unsigned int current;
    int dist;
    Arg shifted;

    if (!selmon->sel)
        return;

    current = selmon->sel->tags & mask;
    if (!current)
        return;

    dist = arg->i % (int)n;
    if (dist < 0)
        dist += (int)n;
    if (dist == 0)
        return;

    current = ((current << dist) | (current >> (n - dist))) & mask;
    shifted.ui = current;
    tag(&shifted);
}

/* ── Keybindings ──────────────────────────────────────────────── */
static const Key keys[] = {
    /* modifier                  key             function        argument */
    /* ── Launch (LARBS-style cluster) ─────────────────────────── */
    { MODKEY,                    XK_minus,       spawn,          SHCMD("command -v dmenuunicode >/dev/null && dmenuunicode || dmenu_run") },
    { MODKEY,                    XK_d,           spawn,          {.v = dmenucmd} },
    { MODKEY|ShiftMask,          XK_d,           spawn,          SHCMD("command -v passmenu >/dev/null && passmenu") },
    { MODKEY,                    XK_Return,      spawn,          {.v = termcmd} },
    { MODKEY|ShiftMask,          XK_Return,      spawn,          SHCMD("$HOME/dotfiles/scripts/spterm-toggle.sh") },
    { MODKEY,                    XK_w,           spawn,          {.v = browsercmd} },
    { MODKEY|ShiftMask,          XK_w,           spawn,          SHCMD("command -v nmtui >/dev/null && (kitty -e nmtui 2>/dev/null || st -e nmtui)") },
    { MODKEY,                    XK_e,           spawn,          {.v = emacscmd} },
    { MODKEY,                    XK_r,           spawn,          {.v = rangercmd} },
    { MODKEY|ShiftMask,          XK_r,           spawn,          SHCMD("kitty -e htop 2>/dev/null || st -e htop") },
    { MODKEY|ShiftMask,          XK_l,           spawn,          {.v = lockcmd} },
    { MODKEY|ShiftMask,          XK_s,           spawn,          {.v = scrotcmd} },
    { MODKEY,                    XK_BackSpace,   spawn,          {.v = sysactcmd} },

    /* ── Audio / media ────────────────────────────────────────── */
    { MODKEY|ShiftMask,          XK_v,           spawn,          {.v = mixercmd} },
    { MODKEY,                    XK_p,           spawn,          {.v = mpctoggle} },
    { MODKEY|ShiftMask,          XK_p,           spawn,          SHCMD("command -v mpc >/dev/null && mpc pause; command -v pauseallmpv >/dev/null && pauseallmpv") },
    { MODKEY,                    XK_comma,       spawn,          {.v = mpcprev}   },
    { MODKEY,                    XK_period,      spawn,          {.v = mpcnext}   },
    { 0, XF86XK_AudioRaiseVolume, spawn,         {.v = volupcmd}  },
    { 0, XF86XK_AudioLowerVolume, spawn,         {.v = voldncmd}  },
    { 0, XF86XK_AudioMute,        spawn,         {.v = mutecmd}   },
    { 0, XF86XK_MonBrightnessUp,  spawn,         {.v = britupcmd} },
    { 0, XF86XK_MonBrightnessDown,spawn,         {.v = britdncmd} },
    { 0, XF86XK_AudioPlay,        spawn,         {.v = mpctoggle} },
    { 0, XF86XK_AudioNext,        spawn,         {.v = mpcnext}   },
    { 0, XF86XK_AudioPrev,        spawn,         {.v = mpcprev}   },

    /* ── Window / layout flow ─────────────────────────────────── */
    { MODKEY,                    XK_q,           killclient,     {0} },
    { MODKEY|ShiftMask,          XK_q,           spawn,          {.v = sysactcmd} },
    { MODKEY,                    XK_b,           togglebar,      {0} },
    { MODKEY,                    XK_j,           focusstack,     {.i = +1} },
    { MODKEY,                    XK_k,           focusstack,     {.i = -1} },
    { MODKEY|ShiftMask,          XK_j,           movestack,      {.i = +1} },
    { MODKEY|ShiftMask,          XK_k,           movestack,      {.i = -1} },
    { MODKEY,                    XK_h,           setmfact,       {.f = -0.05} },
    { MODKEY,                    XK_l,           setmfact,       {.f = +0.05} },
    { MODKEY,                    XK_o,           incnmaster,     {.i = +1} },
    { MODKEY|ShiftMask,          XK_o,           incnmaster,     {.i = -1} },
    { MODKEY,                    XK_t,           setlayout,      {.v = &layouts[0]} },
    { MODKEY,                    XK_f,           setlayout,      {.v = &layouts[1]} },
    { MODKEY,                    XK_i,           setlayout,      {.v = &layouts[2]} },
    { MODKEY,                    XK_space,       zoom,           {0} },
    { MODKEY|ShiftMask,          XK_space,       togglefloating, {0} },
    { MODKEY,                    XK_Tab,         view,           {0} },
    { MODKEY,                    XK_F11,         togglefullscr,  {0} }, /* actualfullscreen */
    { MODKEY,                    XK_0,           view,           {.ui = ~0} },
    { MODKEY|ShiftMask,          XK_0,           tag,            {.ui = ~0} },

    /* ── Gaps / tag travel (LARBS-inspired) ───────────────────── */
    { MODKEY,                    XK_z,           incrgaps,       {.i = +3} },
    { MODKEY,                    XK_x,           incrgaps,       {.i = -3} },
    { MODKEY,                    XK_a,           togglegaps,     {0} },
    { MODKEY|ShiftMask,          XK_a,           defaultgaps,    {0} },
    { MODKEY,                    XK_g,           shiftview,      {.i = -1} },
    { MODKEY|ShiftMask,          XK_g,           shifttag,       {.i = -1} },
    { MODKEY,                    XK_semicolon,   shiftview,      {.i = +1} },
    { MODKEY|ShiftMask,          XK_semicolon,   shifttag,       {.i = +1} },
    { MODKEY,                    XK_Left,        focusmon,       {.i = -1} },
    { MODKEY|ShiftMask,          XK_Left,        tagmon,         {.i = -1} },
    { MODKEY,                    XK_Right,       focusmon,       {.i = +1} },
    { MODKEY|ShiftMask,          XK_Right,       tagmon,         {.i = +1} },

    /* ── Function row utilities ───────────────────────────────── */
    { MODKEY, XK_F1,  spawn, SHCMD("[ -f \"$HOME/dotfiles/docs/larbs-dwm.pdf\" ] && (command -v zathura >/dev/null && zathura \"$HOME/dotfiles/docs/larbs-dwm.pdf\") || (kitty -e man dwm 2>/dev/null || st -e man dwm)") },
    { MODKEY, XK_F2,  spawn, SHCMD("command -v tutorialvids >/dev/null && tutorialvids") },
    { MODKEY, XK_F3,  spawn, SHCMD("command -v displayselect >/dev/null && displayselect") },
    { MODKEY, XK_F4,  spawn, SHCMD("command -v pulsemixer >/dev/null && (kitty -e pulsemixer 2>/dev/null || st -e pulsemixer)") },
    { MODKEY, XK_F5,  spawn, SHCMD("xrdb -merge \"$HOME/.Xresources\"") },
    { MODKEY, XK_F6,  spawn, SHCMD("command -v torwrap >/dev/null && torwrap") },
    { MODKEY, XK_F7,  spawn, SHCMD("command -v td-toggle >/dev/null && td-toggle") },
    { MODKEY, XK_F8,  spawn, SHCMD("command -v mailsync >/dev/null && mailsync") },
    { MODKEY, XK_F9,  spawn, SHCMD("command -v mounter >/dev/null && mounter") },
    { MODKEY, XK_F10, spawn, SHCMD("command -v unmounter >/dev/null && unmounter") },
    { MODKEY, XK_F12, spawn, SHCMD("command -v remaps >/dev/null && remaps") },

    /* ── Tags ─────────────────────────────────────────────────── */
    TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2)
    TAGKEYS(XK_4, 3) TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5)
    TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7) TAGKEYS(XK_9, 8)

    /* ── Scratchpad ────────────────────────────────────────────── */
    { MODKEY,            XK_grave,  spawn, {.v = scratchpadcmd} },

    /* ── Emacs Integration ────────────────────────────────────── */
    { MODKEY,            XK_c,      spawn,    SHCMD("emacsclient -c -e '(org-capture)'") },
    { MODKEY|ControlMask, XK_a,     spawn,    SHCMD("emacsclient -c -e '(org-agenda-list)'") },
    { MODKEY,            XK_n,      spawn,    SHCMD("emacsclient -c -e '(org-roam-node-find)'") },
    { MODKEY|ShiftMask,  XK_e,      spawn,    SHCMD("dmenu-emacs") },

    /* ── dmenu Scripts ───────────────────────────────────────── */
    { MODKEY|ShiftMask,  XK_x,      spawn,    SHCMD("dmenu-power") },
    { MODKEY,            XK_s,      spawn,    SHCMD("dmenu-websearch") },
    { MODKEY|ShiftMask,  XK_period, spawn,    SHCMD("dmenu-emoji") },
    { MODKEY|ShiftMask,  XK_c,      spawn,    SHCMD("dmenu-calc") },

    /* ── Hardened quit ────────────────────────────────────────── */
    { MODKEY|ControlMask|ShiftMask, XK_q,        quit,           {0} },
};

/* ── Mouse Buttons ────────────────────────────────────────────── */
static const Button buttons[] = {
    /* click            mask      button    function        argument */
    { ClkLtSymbol,      0,        Button1,  setlayout,      {0} },
    { ClkLtSymbol,      0,        Button3,  setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,      0,        Button2,  zoom,           {0} },
    { ClkStatusText,    0,        Button1,  sigstatusbar,   {.i = 1} },
    { ClkStatusText,    0,        Button2,  sigstatusbar,   {.i = 2} },
    { ClkStatusText,    0,        Button3,  sigstatusbar,   {.i = 3} },
    { ClkStatusText,    0,        Button4,  sigstatusbar,   {.i = 4} },
    { ClkStatusText,    0,        Button5,  sigstatusbar,   {.i = 5} },
    { ClkStatusText,    0,        6,        sigstatusbar,   {.i = 6} },
    { ClkStatusText,    0,        7,        sigstatusbar,   {.i = 7} },
    { ClkStatusText,    0,        8,        sigstatusbar,   {.i = 8} },
    { ClkStatusText,    0,        9,        sigstatusbar,   {.i = 9} },
    { ClkClientWin,     MODKEY,   Button1,  movemouse,      {0} },
    { ClkClientWin,     MODKEY,   Button2,  togglefloating, {0} },
    { ClkClientWin,     MODKEY,   Button3,  resizemouse,    {0} },
    { ClkTagBar,        0,        Button1,  view,           {0} },
    { ClkTagBar,        0,        Button3,  toggleview,     {0} },
    { ClkTagBar,        MODKEY,   Button1,  tag,            {0} },
    { ClkTagBar,        MODKEY,   Button3,  toggletag,      {0} },
};
