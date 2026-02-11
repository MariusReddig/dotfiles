{ config, ... }: {
  home = {
    activation.linkHyprUserConfig =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfr -T ~/nix/hosts/laptop/home/hyprland/source-files      ~/.config/hypr/user-configs
      '';

    # Linking in Hyprland config
    file.".config/hypr/hyprland.conf".text = ''
      # Linker file configured in the nix config
      source = ./source-files/import-sources.conf
      source = ./user-configs/monitor-layout.conf
      source = ./user-configs/device-layout.conf
    '';
  };
}
