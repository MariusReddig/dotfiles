# Laptop-only Home Manager settings: links ./hyprland to ~/.config/hypr/host-config.
{
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.laptop = moduleWithSystem (
    { self', flakeLocation, ... }:
    { config, pkgs, ... }:
    let
      link = "${self'.packages.link-config}/bin/link-config";
    in
    {
      home.packages = [ pkgs.brightnessctl ];

      home.activation.linkHostConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ${link} ${flakeLocation}/modules/hosts/laptop/hyprland ~/.config/hypr/host-config
      '';
    }
  );
}
