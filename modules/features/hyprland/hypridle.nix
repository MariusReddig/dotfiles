{ ... }:
{
  flake.homeModules.hyprland = {
    home.file.".config/hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock-wrapper # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
      }

      # Dim the backlight shortly before locking, so the drop to the lock screen isn't abrupt.
      listener {
          timeout = 540                                 # 9min
          on-timeout = brightnessctl -s set 10%
          on-resume = brightnessctl -r
      }

      listener {
          timeout = 600                                 # 10min
          on-timeout = loginctl lock-session            # lock screen when timeout has passed
      }

      listener {
          timeout = 900                                 # 15min
          on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
          on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired
      }

      # Suspending is where the real battery savings are — dpms off alone still
      # leaves the CPU/RAM/disk powered. See the "idle inhibit" toggle in the
      # status bar to hold this off on purpose (e.g. while watching a video).
      listener {
          timeout = 1800                                # 30min
          on-timeout = systemctl suspend                # suspend to save battery
      }
    '';
  };
}
