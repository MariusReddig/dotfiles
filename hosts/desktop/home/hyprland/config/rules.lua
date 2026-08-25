---monitor-specific-rules---
--Persistent-Workspaces--
hl.workspace_rule({ workspace = "name:game", monitor = "desc:AOC Q27G4N 2KQR1HA000189" })
hl.workspace_rule({
  workspace = "3",
  monitor = "desc:Samsung Electric Company SAMSUNG",
  default = true,
  persistent = true,
})
hl.workspace_rule({ workspace = "2", monitor = "desc:AOC Q27G4N 2KQR1HA000189", default = true, persistent = true })
hl.workspace_rule({
  workspace = "1",
  monitor = "desc:Fujitsu Siemens Computers GmbH B19-7 LED YV6V005490",
  default = true,
  persistent = true,
})

--Layout-Rules--
hl.workspace_rule({
  workspace = "m[desc:Fujitsu Siemens Computers GmbH B19-7 LED YV6V005490]",
  layout = "scrolling",
  layout_opts = { direction = "down" },
})
hl.workspace_rule({
  workspace = "m[desc:Samsung Electric Company SAMSUNG]",
  layout = "scrolling",
  layout_opts = { direction = "left", column_width = 0.75 },
})

--Window-Rules--
hl.window_rule({
  match = { workspace = "m[desc:Fujitsu Siemens Computers GmbH B19-7 LED YV6V005490]" },
  animation = "slide bottom",
})
hl.window_rule({
  match = { workspace = "m[desc:Samsung Electric Company SAMSUNG]" },
  animation = "slide left",
})
