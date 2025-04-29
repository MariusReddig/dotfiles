# stylix config for the system

{ pkgs, config, ... }:
{
  config = {
    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      cursor = {
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors";
        size = 40;
      };
      fonts = {
        monospace = {
          package = pkgs.unstable.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        serif = config.stylix.fonts.monospace;
        sansSerif = config.stylix.fonts.monospace;
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      image = ./wallpaper; # for Qt-themeing
    };
  };
}
