{ pkgs, config, lib, ... }: {
  #Base package for the MoreWaita icon theme, without it the package is incomplete.
  home.packages = [ pkgs.adwaita-icon-theme ];
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme =
      "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
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
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus";
      light = "Papirus";
    };
    targets.qt.platform = "qtct";
  };
}
