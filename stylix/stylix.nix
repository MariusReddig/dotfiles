# This config is a duplicate of the home configuration and doesnt have to be configured if you dont care about the startup.
# Its only use it to shut up stylix bitching arround about the wallpaper that it "apparently needs" and setting up themes for the bootup
# configure your themes in the home config

{ pkgs, pkgs-unstable, config, ... }:
{
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
        package = pkgs-unstable.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    image = ./wallpaper;
  };
}
