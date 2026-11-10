{ moduleWithSystem, ... }:
{
  flake.homeModules.hyprland = moduleWithSystem (
    { flakeLocation, ... }:
    { pkgs, hostname, ... }:
    {
      # hyprlock.conf can't reference the live wallpaper directly (background.path
      # is static, read once at launch) — this wrapper resolves the pillbar's
      # current wallpaper (see services/Wallpapers.qml) into a live copy of the
      # config before handing off to the real binary. Falls back to the stylix
      # default if pillbar never saved one (e.g. first boot).
      home.packages = [
        (pkgs.writeShellScriptBin "hyprlock-wrapper" ''
          STATE_FILE="$HOME/.local/state/pillbar/wallpaper"
          WALLPAPER="$(cat "$STATE_FILE" 2>/dev/null)"
          if [ -z "$WALLPAPER" ]; then
            WALLPAPER="${flakeLocation}/modules/hosts/${hostname}/stylix/wallpaper.png"
          fi

          RUNTIME_DIR="$XDG_RUNTIME_DIR"
          [ -z "$RUNTIME_DIR" ] && RUNTIME_DIR="/tmp"
          LIVE_CONFIG="$RUNTIME_DIR/hyprlock-live.conf"
          WALLPAPER_ESCAPED=$(printf '%s' "$WALLPAPER" | sed -e 's/[&|\\]/\\&/g')
          sed "s|@WALLPAPER@|$WALLPAPER_ESCAPED|" "$HOME/.config/hypr/hyprlock.conf" > "$LIVE_CONFIG"

          exec ${pkgs.hyprlock}/bin/hyprlock --config "$LIVE_CONFIG"
        '')
      ];

      home.file.".config/hypr/hyprlock.conf".text = ''
        # Hyprlock — matches the pillbar's look: Catppuccin Mocha colours,
        # Inter for text / Symbols Nerd Font for icons (see
        # modules/home/quickshell/config/config/Config.qml), pill-shaped input.
        # @WALLPAPER@ is filled in at lock time by hyprlock-wrapper.

        general {
            grace = 5
            hide_cursor = false
        }

        animations {
            enabled = true
            bezier = linear, 1, 1, 0, 0
            animation = fadeIn, 1, 5, linear
            animation = fadeOut, 1, 5, linear
            animation = inputFieldDots, 1, 2, linear
        }

        background {
            monitor =
            path = @WALLPAPER@
            color = rgb(1E1E2E)
            blur_size = 5
            blur_passes = 2 # 0 disables blurring
            noise = 0.0117
            contrast = 1.3000 # Vibrant!!!
            brightness = 0.8000
            vibrancy = 0.2100
            vibrancy_darkness = 0.0
        }
        input-field {
            monitor =
            size = 500, 50
            rounding = 25 # half the height — a real pill, like the bar
            outline_thickness = 3
            dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true
            outer_color = rgb(313244)
            inner_color = rgb(1E1E2E)
            font_color = rgb(CDD6F4)
            check_color = rgb(89B4FA)
            fail_color = rgb(F38BA8)
            font_family = Inter
            border_size = 2
            fade_on_empty = false
            placeholder_text = Password...
            hide_input = false
            position = 0, -210
            halign = center
            valign = center
        }
        # mid panel
        shape {
            monitor =
            size = 500, 340
            color = rgb(1E1E2E)
            rounding = 22
            border_size = 2
            border_color = rgb(313244)
            rotate = 0
            position = 0, 0
            halign = center
            valign = center
        }
        label {
            monitor =
            text = Hello Marius
            color = rgb(CDD6F4)
            font_size = 30
            font_family = Inter
            position = 0, 100
            halign = center
            valign = center
        }
        label {
            monitor =
            text = cmd[update:18000000] echo "<span font_family='Symbols Nerd Font'>&#xEF37; </span>$(date +'%A, %-d %B %Y')"
            color = rgb(A6ADC8)
            font_size = 18
            font_family = Inter
            position = 0, 25
            halign = center
            valign = center
        }
        label {
            monitor =
            text = cmd[update:1000] echo "<span font_family='Symbols Nerd Font'>󰥔 </span>$(date +'%T')"
            color = rgb(A6ADC8)
            font_size = 18
            font_family = Inter
            position = 0, -25
            halign = center
            valign = center
        }
        label {
            monitor =
            text = cmd[update:60000] echo "<span font_family='Symbols Nerd Font'>󱫡 </span>$(${pkgs.procps}/bin/uptime -p)"
            color = rgb(A6ADC8)
            font_size = 18
            font_family = Inter
            position = 0, -70
            halign = center
            valign = center
        }
        label {
            monitor =
            text = cmd[update:1000] echo "<span font_family='Symbols Nerd Font'>󰁹 </span>$(cat /sys/class/power_supply/BAT0/capacity)%"
            color = rgb(A6ADC8)
            font_size = 18
            font_family = Inter
            position = 0, -115
            halign = center
            valign = center
        }
      '';
    }
  );
}
