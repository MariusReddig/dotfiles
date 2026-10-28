# Desktop-only Home Manager settings: links ./hyprland to ~/.config/hypr/host-config.
{
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.desktop = moduleWithSystem (
    { self', flakeLocation, ... }:
    { config, ... }:
    let
      link = "${self'.packages.link-config}/bin/link-config";
    in
    {
      home.activation.linkHostConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ${link} ${flakeLocation}/modules/hosts/desktop/hyprland ~/.config/hypr/host-config
      '';
    }
  );
}
