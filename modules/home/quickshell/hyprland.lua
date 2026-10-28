-- pillbar (quickshell) integration for Hyprland.
-- Linked to ~/.config/hypr/quickshell.lua by homeModules.quickshell and loaded at the end
-- of hyprland.lua, so every host that imports the quickshell module gets autostart + binds.
-- The config lives directly in ~/.config/quickshell, so it is started without `-c`.
local mainMod = "MOD3"

-- free the keys the core config uses for fuzzel / cliphist
hl.unbind(mainMod .. " + SPACE")
hl.unbind(mainMod .. " + C")

hl.bind(mainMod .. " + B", hl.dsp.global("quickshell:bar-workspaces"))
hl.bind(mainMod .. " + C", hl.dsp.global("quickshell:bar-clock"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.global("quickshell:bar-calendar"))
hl.bind(mainMod .. " + SPACE", hl.dsp.global("quickshell:bar-launcher"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.global("quickshell:bar-wallpapers"))
hl.bind(mainMod .. " + M", hl.dsp.global("quickshell:bar-media"))
hl.bind(mainMod .. " + T", hl.dsp.global("quickshell:bar-tray"))
hl.bind(mainMod .. " + N", hl.dsp.global("quickshell:bar-notifications"))
hl.bind(mainMod .. " + TAB", hl.dsp.global("quickshell:bar-next"))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.global("quickshell:bar-prev"))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.global("quickshell:bar-close"))

hl.on("hyprland.start", function()
  hl.exec_cmd("quickshell")
end)
hl.on("config.reloaded", function()
  hl.exec_cmd("pkill .quickshell-wra; quickshell")
end)
