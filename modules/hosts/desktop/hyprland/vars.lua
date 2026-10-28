hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
    },

    decoration = {
        rounding = 24,
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
        mfact = 0.5,
    },
})
