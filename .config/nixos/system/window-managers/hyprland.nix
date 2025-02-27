{ lib, config, pkgs, inputs, ... }:
{
  options.hyprland = {
    enable = lib.mkEnableOption "enable hyprland window-manager";
  };

  config = lib.mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; # set the flake package
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # make sure to also set the portal package, so that they are in sync
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
      systemPackages = with pkgs; [
        hyprpicker
        hyprlock
        hypridle
        # hyprland-qtutils
        kitty
        hyprpolkitagent
        hyprland-protocols
        swww
      ];
    };
  };
}
