# Gruvbox Dark color scheme
# Shared colors for all programs

{ lib, config, ... }:

let
  # Define color scheme as a local attribute set
  colorScheme = rec {
    name = "Gruvbox Dark";

    # Background colors
    bg = "#282828";
    bg0 = "#282828";
    bg1 = "#3c3836";
    bg2 = "#504945";
    bg3 = "#665c54";
    bg4 = "#7c6f64";

    # Foreground colors
    fg = "#ebdbb2";
    fg0 = "#fbf1c7";
    fg1 = "#ebdbb2";
    fg2 = "#d5c4a1";
    fg3 = "#bdae93";
    fg4 = "#a89984";

    # Colors
    red = "#cc241d";
    green = "#98971a";
    yellow = "#d79921";
    blue = "#458588";
    purple = "#b16286";
    aqua = "#689d6a";
    orange = "#d65d0e";
    gray = "#928374";

    # Bright variants
    bright_red = "#fb4934";
    bright_green = "#b8bb26";
    bright_yellow = "#fabd2f";
    bright_blue = "#83a598";
    bright_purple = "#d3869b";
    bright_aqua = "#8ec07c";
    bright_orange = "#fe8019";

    # Dim variants
    dim_red = "#9d0006";
    dim_green = "#79740e";
    dim_yellow = "#b57614";
    dim_blue = "#076678";
    dim_purple = "#8f3f71";
    dim_aqua = "#427b58";
    dim_orange = "#af3a03";
  };
in {
  # Export as config option for use in other modules
  config = {
    # Make colorScheme available to other modules
    _module.args.colorScheme = colorScheme;

    home.sessionVariables = {
      # Set color scheme in environment for scripts
      GRUVBOX_BG = colorScheme.bg;
      GRUVBOX_FG = colorScheme.fg;
      GRUVBOX_ACCENT = colorScheme.yellow;
    };
  };
}
