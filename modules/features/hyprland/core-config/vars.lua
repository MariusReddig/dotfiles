hl.config({
    input = {
        kb_layout = "de",
        kb_variant = "us",
        kb_options = "caps:hyper",
        follow_mouse = 2,
        accel_profile = "flat",
        sensitivity = 0.0,
        force_no_accel = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
        enforce_permissions = false, -- TODO: Add hyprland-guiutils
    },
    general = {
        gaps_in = 5,
        gaps_out = 11,
        border_size = 2,
        layout = "master",
        col = {
            active_border = "0xA1BDCEFF",
            inactive_border = "0x27272EFF",
        },
        snap = {
            enabled = true,
            window_gap = 10,
            monitor_gap = 10,
            border_overlap = false,
        },
    },
    decoration = {
        rounding = 5,
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "0x1a1a1aee",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
    },
    animations = {
        enabled = true,
    },
    master = {
      mfact = 0.5
    }
})
