{ lib, config, pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    systemPackages = with pkgs; [
      hyprlock
      hypridle
      kitty
      hyprpolkitagent
      hyprland-protocols
    ];
  };
}
