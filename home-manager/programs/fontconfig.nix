# Font configuration - Crystal-clear rendering
# Optimized for LCD screens with RGB subpixel layout

{ config, pkgs, ... }:

{
  # Enable fontconfig
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = [ "Noto Serif" "Liberation Serif" ];
      sansSerif = [ "JetBrainsMono Nerd Font" "Noto Sans" "Liberation Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" "Hack Nerd Font" "Fira Code Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Advanced fontconfig settings
  xdg.configFile."fontconfig/conf.d/10-hinting.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Hinting: slight for sharp text -->
      <match target="font">
        <edit name="hinting" mode="assign">
          <bool>true</bool>
        </edit>
      </match>
      <match target="font">
        <edit name="hintstyle" mode="assign">
          <const>hintslight</const>
        </edit>
      </match>
    </fontconfig>
  '';

  xdg.configFile."fontconfig/conf.d/10-sub-pixel-rgb.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Enable sub-pixel rendering (RGB) -->
      <match target="font">
        <edit name="rgba" mode="assign">
          <const>rgb</const>
        </edit>
      </match>

      <!-- LCD filter for better clarity -->
      <match target="font">
        <edit name="lcdfilter" mode="assign">
          <const>lcddefault</const>
        </edit>
      </match>
    </fontconfig>
  '';

  xdg.configFile."fontconfig/conf.d/10-antialias.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Enable anti-aliasing -->
      <match target="font">
        <edit name="antialias" mode="assign">
          <bool>true</bool>
        </edit>
      </match>

      <!-- Disable auto-hinter (use native hinting) -->
      <match target="font">
        <edit name="autohint" mode="assign">
          <bool>false</bool>
        </edit>
      </match>
    </fontconfig>
  '';

  xdg.configFile."fontconfig/conf.d/11-lcdfilter-default.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Better LCD filtering -->
      <match target="font">
        <edit name="lcdfilter" mode="assign">
          <const>lcdlight</const>
        </edit>
      </match>
    </fontconfig>
  '';

  # Font rendering for specific fonts
  xdg.configFile."fontconfig/conf.d/20-nerd-fonts.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- JetBrainsMono Nerd Font optimizations -->
      <match target="font">
        <test qual="any" name="family">
          <string>JetBrainsMono Nerd Font</string>
        </test>
        <edit name="autohint" mode="assign">
          <bool>false</bool>
        </edit>
        <edit name="hinting" mode="assign">
          <bool>true</bool>
        </edit>
        <edit name="hintstyle" mode="assign">
          <const>hintslight</const>
        </edit>
      </match>
    </fontconfig>
  '';

  # Emoji font configuration
  xdg.configFile."fontconfig/conf.d/30-emoji.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- Emoji font priority -->
      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Noto Sans</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>

      <alias>
        <family>serif</family>
        <prefer>
          <family>Noto Serif</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>

      <alias>
        <family>monospace</family>
        <prefer>
          <family>JetBrainsMono Nerd Font</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

  # Additional font packages for better rendering
  home.packages = with pkgs; [
    # Font rendering libraries
    freetype
    fontconfig

    # Additional fonts
    cantarell-fonts
    dejavu_fonts
    source-code-pro
    source-sans-pro
    source-serif-pro
  ];
}
