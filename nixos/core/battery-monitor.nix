{ config, pkgs, ... }:

let
  batteryMonitorScript = pkgs.writeShellScript "battery-monitor" ''
    #!/usr/bin/env bash

    BATTERY=$(upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}' | sed 's/%//')

    WARNING=20
    SLEEP=5

    if [ "$BATTERY" -le "$WARNING" ] && [ "$BATTERY" -gt "$SLEEP" ]; then
        notify-send "Battery Low" "Battery is at \$BATTERY%!" -u critical
        paplay /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga
    fi

    if [ "$BATTERY" -le "$SLEEP" ]; then
        systemctl suspend
    fi
  '';
in {
  environment.systemPackages = with pkgs; [ libnotify pulseaudio upower ];

  systemd.user.services.battery-monitor = {
    description = "Battery monitor service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${batteryMonitorScript}";
    };
  };

  systemd.user.timers.battery-monitor = {
    description = "Runs battery monitor every 5 minutes";
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
    };
    wantedBy = [ "timers.target" ];
  };
}

