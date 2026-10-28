local mainMod = "MOD3"

---monitor-specific-movement---
-- hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "3" }))
-- hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
-- hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "1" }))
--
-- hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "3" }))
-- hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
-- hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "1" }))

-- hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("pkill fuzzel ; fuzzel"))
hl.unbind(mainMod .. " + SHIFT + E")
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("GTK_THEME=Adwaita:dark thunar"))

-- Quickshell binds come from modules/home/quickshell/hyprland.lua
