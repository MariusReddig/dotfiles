{ pkgs, ... }: {
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
      waybar

      (writeShellScriptBin "hyprland-waybar" ''
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
            pkill -SIGINT waybar  # Hide waybar
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

      (writeShellScriptBin "hyprland-gabs" ''
        # Get values from config (handles spaces, tabs, etc.)
        CONFIG_GAPS_IN=$(grep -E "^\s*gaps_in\s*=" ~/.config/hypr/core/core/decoration.conf 2>/dev/null | sed 's/#.*//' | awk -F= '{print $2}' | xargs)
        CONFIG_GAPS_OUT=$(grep -E "^\s*gaps_out\s*=" ~/.config/hypr/core/core/decoration.conf 2>/dev/null | sed 's/#.*//' | awk -F= '{print $2}' | xargs)
        CURRENT_GAPS_IN=$(hyprctl getoption general:gaps_in | grep -oP 'custom type:\s*\K[^\s]+')
        CURRENT_GAPS_OUT=$(hyprctl getoption general:gaps_out | grep -oP 'custom type:\s*\K[^\s]+')

        if [ $# -eq 0 ]; then
          echo "Usage: $0 [on|off|toggle]"
          exit 1
        fi

        case "$1" in
          on)
            hyprctl keyword general:gaps_in $CONFIG_GAPS_IN
            hyprctl keyword general:gaps_out $CONFIG_GAPS_OUT
            echo "gabs on"
            ;;
          off)
            hyprctl keyword general:gaps_in 0
            hyprctl keyword general:gaps_out 0
            echo "gabs off"
            ;;
          toggle)
            if [ $CURRENT_GAPS_IN -ne 0 ] && [ $CURRENT_GAPS_OUT -ne 0 ] ; then
              hyprctl keyword general:gaps_in 0
              hyprctl keyword general:gaps_out 0
            else
              hyprctl keyword general:gaps_in "$CONFIG_GAPS_IN"
              hyprctl keyword general:gaps_out "$CONFIG_GAPS_OUT"
            fi
            echo "gabs toggled"
            ;;
          *)
            echo "Invalid argument. Usage: $0 [on|off|toggle]"
            exit 1
            ;;
        esac
      '')

      (writeShellScriptBin "hyprland-borderrounding" ''
        # Get values from config (handles spaces, tabs, etc.)
        CONFIG_ROUNDING=$(grep -E "^\s*rounding\s*=" ~/.config/hypr/core/core/decoration.conf 2>/dev/null | sed 's/#.*//' | awk -F= '{print $2}' | xargs)
        CURRENT_ROUNDING=$(hyprctl getoption decoration:rounding | grep -oP 'int:\s*\K[^\s]+')

        if [ $# -eq 0 ]; then
          echo "Usage: $0 [on|off|toggle]"
          exit 1
        fi

        case "$1" in
          on)
            hyprctl keyword decoration:rounding $CONFIG_ROUNDING
            echo "gabs on"
            ;;
          off)
            hyprctl keyword decoration:rounding 0
            echo "gabs off"
            ;;
          toggle)
            if [ $CURRENT_ROUNDING -ne 0 ]; then
            hyprctl keyword decoration:rounding 0
            else
            hyprctl keyword decoration:rounding $CONFIG_ROUNDING
            fi
            echo "gabs toggled"
            ;;
          *)
            echo "Invalid argument. Usage: $0 [on|off|toggle]"
            exit 1
            ;;
        esac
      '')

      (writeShellScriptBin "hyprland-psudo-fullscreen" ''
        if [ $# -eq 0 ]; then
          echo "Usage: $0 [on|off|toggle]"
          exit 1
        fi

        case "$1" in
          on)
            hyprland-waybar on
            hyprland-gabs on
            hytrland-borderrounding on
            echo "psudo-fullscreen on"
            ;;
          off)
            hyprland-waybar off
            hyprland-gabs off
            hyprland-borderrounding off
            echo "psudo-fullscreen off"
            ;;
          toggle)
            hyprland-waybar toggle
            hyprland-gabs toggle
            hyprland-borderrounding toggle
            echo "toggle psudo-fullscreen"
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
