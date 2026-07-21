{ config, ... }: {
  home.activation.linkHyprHostConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfrT ~/nix/hosts/desktop/home/hyprland/config  ~/.config/hypr/host-config
  '';
}
