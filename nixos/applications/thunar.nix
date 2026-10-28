{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    thunar.enable = lib.mkEnableOption "enable thunar module";
  };
  config = lib.mkIf config.thunar.enable {

    programs.thunar.enable = true;
    programs.xfconf.enable = true;

    programs.thunar.plugins = [
      pkgs.thunar
      pkgs.xfconf
      pkgs.tumbler
      pkgs.thunar-archive-plugin
      pkgs.thunar-volman
      pkgs.thunar-media-tags-plugin
      pkgs.gvfs
      pkgs.glib
      pkgs.file-roller
    ];

    # programs.file-roller.enable = true; # enables fileroller for archive plugin
    services.gvfs.enable = true; # Mount, trash, and other functionalities
    services.tumbler.enable = true; # Thumbnail support for images

  };
}
