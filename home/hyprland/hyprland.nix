{ config, ... }:
{
  home.activation.linkHyprCoreFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T ~/nix/home/hyprland      ~/.config/hypr/core
  '';
}
