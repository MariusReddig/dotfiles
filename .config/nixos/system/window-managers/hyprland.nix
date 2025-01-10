{ lib, config, pkgs, inputs, ... }:
{
  options.hyprland = {
    enable = lib.mkEnableOption "enable hyprland window-manager";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

    environment.systemPackages = with pkgs; [
      hyprpicker
      hyprlock
      hypridle
      hyprland-qtutils
      kitty
      hyprpolkitagent
      xdg-desktop-portal-hyprland
      hyprland-protocols
      swww
    ];
  };
}
