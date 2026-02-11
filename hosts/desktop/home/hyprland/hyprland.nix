{ config, ... }: {
  home = {
    activation.linkHyprUserConfig =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfrT ~/nix/hosts/desktop/home/hyprland/source-files   ~/.config/hypr/user-configs
      '';

    # Linking in Hyprland config
    file.".config/hypr/hyprland.conf".text = ''
      # Linker file configured in the nix config
      source = ./source-files/import-sources.conf
      source = ./user-configs/monitor-layout.conf
    '';
  };
}
