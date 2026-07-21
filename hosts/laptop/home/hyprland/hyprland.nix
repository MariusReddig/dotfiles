{ config, ... }: {
  home = {
    activation.linkHyprHostConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfrT ~/nix/hosts/laptop/home/hyprland/config   ~/.config/hypr/host-config
    '';
  };
}
