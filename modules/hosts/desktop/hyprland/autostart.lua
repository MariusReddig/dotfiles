hl.on("hyprland.start", function()
  hl.exec_cmd("legcord --disable-features=WaylandFractionalScaleV1")
  hl.exec_cmd("signal-desktop --disable-features=WaylandFractionalScaleV1")
end)
