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

      (writeShellScriptBin "toggle-waybar" ''
        if [ $# -eq 0 ]; then
          echo "Usage: $0 [on|off|toggle]"
          exit 1
        fi

        case "$1" in
          on)
            pkill -SIGUSR2 waybar  # Show waybar
            echo "Waybar shown"
            ;;
          off)
            pkill -SIGUSR1 waybar  # Hide waybar
            echo "Waybar hidden"
            ;;
          toggle)
            pkill -SIGUSR1 waybar  # Toggles waybar (USR1 works as toggle)
            echo "Waybar toggled"
            ;;
          *)
            echo "Invalid argument. Usage: $0 [on|off|toggle]"
            exit 1
            ;;
        esac
      '')
    ];
  };
}
