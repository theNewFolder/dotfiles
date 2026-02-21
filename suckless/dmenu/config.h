/* dmenu topbar eyecandy profile (Gruvbox Baby ultra-dark) */
static int topbar = 1;
static const char *fonts[] = {
  "DankMono Nerd Font:size=13:antialias=true:autohint=false"
};
static const char *prompt = NULL;
static const char *colors[SchemeLast][2] = {
  /*               fg          bg       */
  [SchemeNorm] = { "#ebdbb2", "#0d0e0f" },
  [SchemeSel]  = { "#0d0e0f", "#fe8019" },
  [SchemeOut]  = { "#0d0e0f", "#83a598" },
};
static unsigned int lines = 0;
static const char worddelimiters[] = " ";
