hl.on("hyprland.start", function()
    -- Core stuff
    hl.exec_cmd("dunst")
    hl.exec_cmd("/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1")
    hl.exec_cmd("firewalld")
    hl.exec_cmd("start-xdg-desktop-portal")
    hl.exec_cmd("wl-paste --watch cliphist store")
    -- Audio
    hl.exec_cmd("initialize-sinks")
    hl.exec_cmd("easyeffects --hide-window")
    -- Workspace Interface
    hl.exec_cmd("awww-daemon")
    -- hl.exec_cmd("waybar")
    hl.exec_cmd("nextcloud")
    hl.exec_cmd("steam -silent")
    hl.exec_cmd("signal-desktop --disable-features=WaylandFractionalScaleV1")
    hl.exec_cmd("zapzap")
end)
hl.on("config.reloaded", function()
    -- Reload
    -- Workspace
    -- Interface
    hl.exec_cmd("chwp -r")
    -- hl.exec_cmd("pkill waybar; waybar")
    hl.exec_cmd("pkill blueman-applet; blueman-applet")
    hl.exec_cmd("pkill nm-applet; nm-applet")
end)
