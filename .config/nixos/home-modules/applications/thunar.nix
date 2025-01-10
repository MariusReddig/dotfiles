{ config, pkgs, lib, ... }:
{
  options = {
    thunar.enable = lib.mkEnableOption "enable thunar module";
  };
  config = lib.mkIf config.thunar.enable {

    home.packages = [
      pkgs.xfce.thunar
      pkgs.xfce.xfconf
      pkgs.xfce.tumbler
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-volman
      pkgs.xfce.thunar-media-tags-plugin
      pkgs.gvfs
      pkgs.glib
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "thunar.desktop" ];
      };
    };
  };
}
