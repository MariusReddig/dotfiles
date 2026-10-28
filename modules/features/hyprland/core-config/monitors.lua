local function toggle_monitor(monitor_name)
  hl.timer(function()
    hl.dispatch(hl.dsp.dpms({ action = "toggle", monitor = monitor_name }))
  end, { timeout = 500, type = "oneshot" })
end

_G.toggle_monitor = toggle_monitor
