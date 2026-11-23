hl.on("hyprland.start", function()
  -- Core stuff
  hl.exec_cmd("/usr/lib/polkit-gnome-polkit-gnome-authentication-agent-1")
  hl.exec_cmd("start-xdg-desktop-portal")
  hl.exec_cmd("wl-paste --watch cliphist store")
  -- Audio
  hl.exec_cmd("initialize-sinks")
  hl.exec_cmd("easyeffects --hide-window")
  -- Workspace Interface
  hl.exec_cmd("awww-daemon")
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
