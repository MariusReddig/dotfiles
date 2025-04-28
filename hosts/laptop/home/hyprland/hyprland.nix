{ config, ... }:
{
  home = {
    activation.linkHyprUserConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfr -T ~/nix/hosts/desktop/home/hyprland/config      ~/.config/hypr/user-configs
    '';

    # Linking in Hyprland config
    file.".config/hypr/hyprland.conf".text = ''
      # Linker file configured in the nix config
      source = ./core/init.conf
      source = ./user-configs/monitor-layout.conf
    '';
  };
}
