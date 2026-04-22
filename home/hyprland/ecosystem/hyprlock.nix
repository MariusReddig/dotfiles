{ username, host, pkgs, ... }: {
  home.file.".config/hypr/hyprlock.conf".text = ''
    # Hyprlock
    # Original config submitted by https://github.com/SherLock707

    general {
        grace = 5
    }
    background {
        monitor =
        path = "/home/${username}/nix/hosts/${host}/home/stylix/wallpaper.png"
        blur_size = 5
        color = rgb(FFE2C4)
        blur_passes = 1 # 0 disables blurring
        noise = 0.0117
        contrast = 1.3000 # Vibrant!!!
        brightness = 0.8000
        vibrancy = 0.2100
        vibrancy_darkness = 0.0
    }
    input-field {
        monitor =
        size = 500, 30
        outline_thickness = 3
        dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true
        outer_color = rgb(27272E)
        inner_color = rgb(0F0F17)
        font_color = rgb(A1BDCE)
        rounding = 8
        border_size = 0
        #fade_on_empty = true
        placeholder_text =  # Text rendered in the input box when it's empty.
        hide_input = false
        position = 0, -210
        halign = center
        valign = center
    }
    # mid panel
    shape {
        monitor =
        size = 500, 340
        color = rgb(0F0F17)
        rounding = 8
        border_size = 2
        border_color = rgb(27272E)
        rotate = 0
        position = 0, 0
        halign = center
        valign = center
    }
    label {
        monitor =
        text = Hello Marius
        color = rgb(A1BDCE)
        inner_color = rgb(0F0F17)
        font_size = 30
        font_family = JetBrains Mono Nerd Font 10
        position = 0, 100
        halign = center
        valign = center
    }
    label {
        monitor =
        text = cmd[update:18000000] echo "  " $(date +'%A, %-d %B %Y')
        color = rgb(A1BDCE)
        inner_color = rgb(0F0F17)
        font_size = 18
        font_family = JetBrains Mono Nerd Font 10
        position = 0, 25
        halign = center
        valign = center
    }
    label {
        monitor =
        text = cmd[update:1000] echo " 󰥔 " $(date +'%T')
        color = rgb(A1BDCE)
        inner_color = rgb(0F0F17)
        font_size = 18
        font_family = JetBrains Mono Nerd Font 10
        position = 0, -25
        halign = center
        valign = center
    }
    label {
        monitor =
        text = cmd[update:60000] echo " 󱫡  "$(${pkgs.procps}/bin/uptime -p)
        color = rgb(A1BDCE)
        font_size = 18
        font_family = JetBrains Mono Nerd Font 10
        position = 0, -70
        halign = center
        valign = center
    }
    label {
      text = cmd[update:1000] echo "󰁹 $(cat /sys/class/power_supply/BAT0/capacity)%"
      font_size = 18
      font_family = JetBrains Mono Nerd Font 10
      color = rgb(A1BDCE)
      position = 0, -115
      halign = center
      valign = center
    }
  '';
}
