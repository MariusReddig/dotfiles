{ config, ... }: {
  home = {
    activation.linkHyprUserConfig =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfr -T ~/nix/hosts/laptop/home/hyprland/source-files      ~/.config/hypr/user-configs
      '';

    # Linking in Hyprland config
    file.".config/hypr/hyprland.conf".text = ''
      source = ~/.config/hypr/source-files/import-sources.conf
      source = ~/.config/hypr/user-configs/monitor-layout.conf
      source = ~/.config/hypr/user-configs/device-layout.conf
    '';
  };
}
