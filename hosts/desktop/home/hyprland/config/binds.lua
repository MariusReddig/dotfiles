local mainMod = "MOD3"

---monitor-specific-movement---
-- hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "3" }))
-- hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
-- hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "1" }))
--
-- hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "3" }))
-- hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
-- hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "1" }))

hl.unbind(mainMod .. "+ SPACE")
-- hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("pkill fuzzel ; fuzzel"))
hl.unbind(mainMod .. " + SHIFT + E")
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("GTK_THEME=Adwaita:dark thunar"))

-- Quickshell stuff
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
hl.bind(mainMod .. " + B", hl.dsp.global("quickshell:bar-workspaces"))
