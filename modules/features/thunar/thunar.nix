{
  self,
  ...
}:
{
  flake.nixosModules.thunar =
    {
      pkgs,
      ...
    }:
    {
      programs.thunar.enable = true;
      programs.xfconf.enable = true;

      # the xfce.* names are deprecated, these packages live at top level now
      programs.thunar.plugins = with pkgs; [
        thunar
        xfconf
        tumbler
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
        gvfs
        glib
        file-roller
      ];

      services.gvfs.enable = true; # Mount, trash, and other functionalities
      services.tumbler.enable = true; # Thumbnail support for images
    };
}
