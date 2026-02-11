{ config, pkgs, ... }: {
  home.activation.linkHyprEcoSysConfigs =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfr ~/nix/home/hyprland/ecosystem/hypridle.conf ~/.config/hypr/hypridle.conf
      ln -sfr ~/nix/home/hyprland/ecosystem/hyprlock.conf ~/.config/hypr/hyprlock.conf
    '';
}
