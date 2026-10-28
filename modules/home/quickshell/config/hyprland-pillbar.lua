-- pillbar keybinds for Hyprland's Lua config.
-- Put this file next to hyprland.lua and add:   require("hyprland-pillbar")

hl.bind("SUPER+W",           hl.dsp.global("quickshell:bar-workspaces"))
hl.bind("SUPER+C",           hl.dsp.global("quickshell:bar-clock"))
hl.bind("SUPER+SHIFT+C",     hl.dsp.global("quickshell:bar-calendar"))
hl.bind("SUPER+SPACE",       hl.dsp.global("quickshell:bar-launcher"))
hl.bind("SUPER+SHIFT+SPACE", hl.dsp.global("quickshell:bar-wallpapers"))
hl.bind("SUPER+M",           hl.dsp.global("quickshell:bar-media"))
hl.bind("SUPER+T",           hl.dsp.global("quickshell:bar-tray"))
hl.bind("SUPER+N",           hl.dsp.global("quickshell:bar-notifications"))
hl.bind("SUPER+TAB",         hl.dsp.global("quickshell:bar-next"))
hl.bind("SUPER+SHIFT+TAB",   hl.dsp.global("quickshell:bar-prev"))
hl.bind("SUPER+ESCAPE",      hl.dsp.global("quickshell:bar-close"))

-- Start pillbar with Hyprland (replaces `exec-once = qs -c pillbar`).
hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c pillbar")
end)
