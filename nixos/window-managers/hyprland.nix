{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    # withUWSM = true;
  };

  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors = {
  #     hyprland = {
  #       prettyName = "Hyprland";
  #       comment = "Hyprland compositor managed by UWSM";
  #       binPath = "/run/current-system/sw/bin/Hyprland";
  #     };
  #   };
  # };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1";
    sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
    systemPackages = with pkgs; [
      hyprlock
      hypridle
      hyprpolkitagent
      hyprland-protocols
    ];
  };
}
