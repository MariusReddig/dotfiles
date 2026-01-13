{ pkgs, ... }:

let
  batteryMonitorScript = pkgs.writeShellScript "battery-monitor.sh" ''
    BATTERY="/sys/class/power_supply/BAT0"
    STATUS_FILE="$BATTERY/status"
    CAPACITY_FILE="$BATTERY/capacity"

    STATE_FILE="/run/battery-monitor-state"
    mkdir -p "$(dirname "$STATE_FILE")"
    touch "$STATE_FILE"

    LAST_WARNING=$(cat "$STATE_FILE")

    CAPACITY=$(cat "$CAPACITY_FILE")
    STATUS=$(cat "$STATUS_FILE")

    # ${pkgs.libnotify}/bin/notify-send "Test" "Battery at ''${CAPACITY}%"
    # sudo -u $USER ${pkgs.wireplumber}/bin/pw-play ${pkgs.kdePackages.oxygen-sounds}/share/sounds/oxygen/stereo/battery-low.ogg

    # Only warn when discharging
    if [[ "$STATUS" != "Discharging" ]]; then
        exit 0
    fi

    # 20% warning
    if [[ $CAPACITY -le 20 && $LAST_WARNING != "warn20" && $CAPACITY -gt 5 ]]; then
        ${pkgs.libnotify}/bin/notify-send "Battery Low" "Battery at ''${CAPACITY}%"
        sudo -u $USER ${pkgs.wireplumber}/bin/pw-play ${pkgs.kdePackages.oxygen-sounds}/share/sounds/oxygen/stereo/battery-low.ogg
        echo "warn20" > "$STATE_FILE"
        exit 0
    fi

    # 5% critical — suspend
    if [[ $CAPACITY -le 5 && $LAST_WARNING != "crit5" ]]; then
        ${pkgs.libnotify}/bin/notify-send "Battery Critical" "Suspending now (battery at ''${CAPACITY}%)"
        systemctl suspend
        echo "crit5" > "$STATE_FILE"
        exit 0
    fi

    # Reset when charging
    if [[ "$STATUS" == "Charging" ]]; then
        echo "" > "$STATE_FILE"
    fi
  '';
in {

  systemd.user.services.battery-monitor = {
    description = "Battery Monitor Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = batteryMonitorScript;
    };
    environment = { XDG_RUNTIME_DIR = "/run/user/1000"; };
  };

  systemd.user.timers.battery-monitor = {
    description = "Battery Monitor Timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "30s";
      OnUnitActiveSec = "60s";
    };
  };
}

