# Stylix theming: system side (nixosModules.stylix) and user side (homeModules.stylix).
# The Home Manager part needs the NixOS part, stylix injects its HM module from there.
{ self, inputs, ... }:
{
  flake.nixosModules.stylix =
    { config, pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

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
        image = ./wallpaper; # for Qt-theming
      };
    };

  flake.homeModules.stylix =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      # Base package for the MoreWaita icon theme, without it the package is incomplete.
      home.packages = [ pkgs.adwaita-icon-theme ];
      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
        cursor = {
          package = pkgs.capitaine-cursors;
          name = "capitaine-cursors";
          size = lib.mkDefault 40;
        };
        fonts = {
          sizes = {
            popups = 24;
            applications = 10;
          };
          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font";
          };
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme;
          dark = "Papirus";
          light = "Papirus";
        };
        targets.qt.platform = "qtct";
      };
    };
}
