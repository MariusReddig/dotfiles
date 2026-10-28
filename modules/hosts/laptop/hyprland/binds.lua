local mainMod = "MOD3"

---monitor-specific-movement---
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "1" }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "1" }))
