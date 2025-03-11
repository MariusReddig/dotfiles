{ config, pkgs, lib, ... }:
let
  cfg = config.hypr-oni;
in
{
  options.hypr-oni = {
    enable = lib.mkEnableOption "enable oni-theme";
  };

  config = lib.mkIf cfg.enable {

    gtk = {
      enable = true;

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        name = "MoreWaita";
        package = pkgs.morewaita-icon-theme;
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
          color-scheme = "prefer-dark"
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
          color-scheme = "prefer-dark"
        '';
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qt5ct";
      # style = "adwaita-dark";
    };

    home = {
      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "capitaine-cursors";
        size = 40;
        package = pkgs.capitaine-cursors;
      };
    };
  };
}
