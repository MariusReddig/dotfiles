-- predefined parameters
local mainMod = "MOD3"
--local  mainMod = "SUPER"

-- predefined functions
local function toggle_displays()
    hl.timer(function()
        hl.dispatch(hl.dsp.dpms({ action = "toggle" }))
    end, { timeout = 500, type = "oneshot" })
end

local function waybar_toggle()
    hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")
    -- TODO: set bordersize to 0 (pseudo-fullscreen)
end

---Config---
-- Screen
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true })
hl.bind("XF86Display", function()
    toggle_displays()
end, {})

-- Audio
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl --all-players play"), { repeating = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl --all-players pause"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%- -l 1"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%+ -l 1"), { repeating = true })

-- Mic
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { repeating = true })

hl.bind("XF86NotificationCenter", hl.dsp.no_op(), {})
hl.bind("XF86PickupPhone", hl.dsp.no_op(), {})
hl.bind("XF86HangupPhone", hl.dsp.no_op(), {})
hl.bind("XF86Favorites", hl.dsp.no_op(), {})

---Focus-movement---
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))

---Workspace-movement---
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind(mainMod .. " + g", hl.dsp.focus({ workspace = "name:game" }))

---Window-movement---
-- relative window movement
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))

-- move to next available empty workspace
hl.bind(mainMod .. " + SHIFT + n", hl.dsp.window.move({ workspace = "emptynm", follow = true }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
hl.bind(mainMod .. " + SHIFT + g", hl.dsp.window.move({ workspace = "name:game" }))

---Window-modification---
-- Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { keep_aspect_ratio = true, mouse = true })
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.resize(), { mouse = true })

-- Window-modification
hl.bind(mainMod .. " + D", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.kill())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

--Master-layout--
hl.bind(mainMod .. " + S", hl.dsp.layout("swapwithmaster master"))
hl.bind(mainMod .. " + R", hl.dsp.layout("cyclenext loop"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.layout("rollnext"))
hl.bind(mainMod .. " + Left", hl.dsp.layout("mfact -0.1"))
hl.bind(mainMod .. " + Right", hl.dsp.layout("mfact +0.1"))

---Specific-keybinds---

-- Hyprland shortcuts
hl.bind(mainMod .. " + SHIFT + U ", hl.dsp.exec_cmd("hyprctl reload; chwp -r"))
hl.bind(mainMod .. " + ALT + Q", hl.dsp.exec_cmd("hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'"))
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("hyprshutdown -t 'Shutting down...' --post-cmd 'reboot'"))
-- TODO: Add Sessionlock and Idlesleep

-- Waybar
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + B", function()
    waybar_toggle()
end)
hl.bind(mainMod .. " + SHIFT + M ", function()
    toggle_displays()
end)

--Screenshot
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

--color-picker
hl.bind("ALT + Print", hl.dsp.exec_cmd("wl-copy $(hyprpicker)"))

--terminal
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty -e tmux new-session -A -s default"))

--clipboard
--hl.bind(mainMod .. " + C", hl.dsp.exec_cmd())cliphist list | fuzzel --dmenu | cliphist decode | wl-copy
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("fuzzel-cliphist-img"))

--file-browser
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + E ", hl.dsp.exec_cmd("kitty -e superfile"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd("kitty -e tmux new-session -A -s default \\; neww superfile;"))

--application search
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("pkill fuzzel ; fuzzel"))

--browser
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("firefox -P dark"))
