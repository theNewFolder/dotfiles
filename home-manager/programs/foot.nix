# Foot terminal configuration - Vibrant Gruvbox with eye candy

{ config, pkgs, colorScheme, ... }:

{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=11";
        dpi-aware = "yes";
        pad = "10x10";  # Padding for aesthetics
      };

      cursor = {
        style = "beam";
        beam-thickness = 2;
        blink = "yes";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      # Vibrant Gruvbox Dark colors
      colors = {
        alpha = 0.95;  # Slight transparency
        background = colorScheme.bg;
        foreground = colorScheme.fg;

        ## Normal colors
        regular0 = colorScheme.bg0;     # black
        regular1 = colorScheme.red;     # red
        regular2 = colorScheme.green;   # green
        regular3 = colorScheme.yellow;  # yellow
        regular4 = colorScheme.blue;    # blue
        regular5 = colorScheme.purple;  # magenta
        regular6 = colorScheme.aqua;    # cyan
        regular7 = colorScheme.fg4;     # white

        ## Bright colors
        bright0 = colorScheme.gray;           # bright black
        bright1 = colorScheme.bright_red;     # bright red
        bright2 = colorScheme.bright_green;   # bright green
        bright3 = colorScheme.bright_yellow;  # bright yellow
        bright4 = colorScheme.bright_blue;    # bright blue
        bright5 = colorScheme.bright_purple;  # bright magenta
        bright6 = colorScheme.bright_aqua;    # bright cyan
        bright7 = colorScheme.fg0;            # bright white

        ## Selection colors
        selection-foreground = colorScheme.bg;
        selection-background = colorScheme.bright_yellow;

        ## URL colors
        urls = colorScheme.bright_blue;
      };

      bell = {
        urgent = "yes";
        notify = "yes";
        visual = "yes";
      };

      scrollback = {
        lines = 10000;
        multiplier = 3.0;
      };
    };
  };
}
