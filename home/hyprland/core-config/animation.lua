---Animations---
hl.curve("slide", { type = "bezier", points = { { 0.22, 1.0 }, { 0.36, 1.0 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "slide", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 20, bezier = "slide" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "slide", style = "once" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "slide", style = "slidefade" })
