---Internal-stuff---
require("core-config.lib")

---Core-configs---
require("core-config.vars")
require("core-config.rules")
require("core-config.animation")
require("core-config.binds")
require("core-config.gestures")
require("core-config.autostart")

---Host-specific-configs---
if is_file_exists(HOME .. "/.config/hypr/host-config/monitors.lua") then
  require("host-config.monitors")
else
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.0 })
end
if is_file_exists(HOME .. "/.config/hypr/host-config/devices.lua") then
  require("host-config.devices")
end
if is_file_exists(HOME .. "/.config/hypr/host-config/vars.lua") then
  require("host-config.vars")
end
if is_file_exists(HOME .. "/.config/hypr/host-config/rules.lua") then
  require("host-config.rules")
end
if is_file_exists(HOME .. "/.config/hypr/host-config/animation.lua") then
  require("host-config.animation")
end
if is_file_exists(HOME .. "/.config/hypr/host-config/binds.lua") then
  require("host-config.binds")
end
if is_file_exists(HOME .. "/.config/hypr/host-config/gestures.lua") then
  require("host-config.gestures")
end
if is_file_exists(HOME .. "/.config/hypr/host-config/autostart.lua") then
  require("host-config.autostart")
end
