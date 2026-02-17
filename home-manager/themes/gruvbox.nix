# Gruvbox Dark color scheme
# Shared colors for all programs

{ lib, config, ... }:

let
  # Define color scheme as a local attribute set
  colorScheme = rec {
    name = "Gruvbox Dark - Vibrant";

    # Background colors - Darker and richer
    bg = "#1d2021";      # Darker base (was #282828)
    bg0 = "#1d2021";     # Darker base
    bg1 = "#282828";     # Darker than original bg1
    bg2 = "#3c3836";     # Shifted darker
    bg3 = "#504945";     # Shifted darker
    bg4 = "#665c54";     # Shifted darker

    # Foreground colors - Brighter and more vibrant
    fg = "#fbf1c7";      # Brighter (was #ebdbb2)
    fg0 = "#fffbdd";     # Even brighter
    fg1 = "#fbf1c7";     # Bright cream
    fg2 = "#ebdbb2";     # Warm white
    fg3 = "#d5c4a1";     # Lighter tan
    fg4 = "#bdae93";     # Medium tan

    # Colors - More saturated and vibrant
    red = "#d42020";       # More saturated red
    green = "#a8b020";     # More vibrant green
    yellow = "#e8a50e";    # More saturated yellow
    blue = "#4f96c8";      # More vibrant blue
    purple = "#c8509b";    # More saturated purple
    aqua = "#70b060";      # More vibrant aqua
    orange = "#e86420";    # More saturated orange
    gray = "#a09080";      # Warmer gray

    # Bright variants - Extra vibrant
    bright_red = "#ff5050";      # Super vibrant red
    bright_green = "#d0f020";    # Neon green
    bright_yellow = "#ffd040";   # Golden yellow
    bright_blue = "#60c0ff";     # Sky blue
    bright_purple = "#ff60d0";   # Hot pink
    bright_aqua = "#60ff90";     # Mint green
    bright_orange = "#ff9030";   # Bright orange

    # Dim variants - Still visible but darker
    dim_red = "#801010";
    dim_green = "#606010";
    dim_yellow = "#806010";
    dim_blue = "#104060";
    dim_purple = "#603050";
    dim_aqua = "#206040";
    dim_orange = "#803010";
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
