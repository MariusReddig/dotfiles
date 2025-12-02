{ config, pkgs, lib, ... }: {
  options = { thunar.enable = lib.mkEnableOption "enable thunar module"; };
  config = lib.mkIf config.thunar.enable {

    programs.thunar.enable = true;
    programs.xfconf.enable = true;

    programs.thunar.plugins = [
      pkgs.xfce.thunar
      pkgs.xfce.xfconf
      pkgs.xfce.tumbler
      pkgs.xfce.thunar-archive-plugin
      pkgs.xfce.thunar-volman
      pkgs.xfce.thunar-media-tags-plugin
      pkgs.gvfs
      pkgs.glib
      pkgs.file-roller
    ];

    # programs.file-roller.enable = true; # enables fileroller for archive plugin
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

  };
}
