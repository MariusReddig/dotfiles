# wallust: generates the Qt/GTK color palette from whatever wallpaper is
# currently set, at runtime (no rebuild). Triggered from chwp and the
# quickshell wallpaper picker. Stylix keeps owning everything that isn't a
# per-wallpaper color (fonts, cursor, icons, Firefox, Plymouth).
{ moduleWithSystem, ... }:
{
  flake.homeModules.wallust = moduleWithSystem (
    { self', flakeLocation, ... }:
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [ pkgs.wallust ];

      # Plain `ln -sfrT` can't replace ~/.config/wallust if wallust itself
      # already created it as a real directory (e.g. on a prior manual run) -
      # use link-config, which backs that up instead of silently no-op'ing.
      home.activation.linkWallustConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ${self'.packages.link-config}/bin/link-config ${flakeLocation}/modules/features/wallust/config ~/.config/wallust
      '';

      # Qt: only the platform engine/style is set declaratively here. The
      # actual colors are written at runtime by wallust to
      # ~/.config/qt{5,6}ct/colors/wallust.conf (see wallust.toml).
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "adwaita-dark";
      };
      qt.qt5ctSettings.Appearance = {
        custom_palette = true;
        color_scheme_path = "${config.home.homeDirectory}/.config/qt5ct/colors/wallust.conf";
      };
      qt.qt6ctSettings.Appearance = {
        custom_palette = true;
        color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/wallust.conf";
      };

      # GTK: gtk.css just imports colors.css, which wallust (re)writes at
      # runtime next to it. colorScheme = "dark" flips the
      # gtk-application-prefer-dark-theme flag (and the dconf color-scheme),
      # without which Adwaita renders light-mode widget chrome (e.g. Thunar's
      # search entry) no matter what colors.css overrides.
      gtk = {
        enable = true;
        colorScheme = "dark";
        gtk3.extraCss = ''@import url("colors.css");'';
        gtk4.extraCss = ''@import url("colors.css");'';
      };
    }
  );
}
