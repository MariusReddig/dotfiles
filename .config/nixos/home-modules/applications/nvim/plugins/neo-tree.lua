require("neo-tree").setup({
	filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = true },
		window = {
			position = "left", -- Position the NeoTree window on the left side
			width = 30, -- Set the width of the NeoTree window
			mappings = {
				["<space>"] = "none",
				["l"] = "open",
				["h"] = "close_node",
				["<S-cr>"] = "open_tabnew",
			},
		},
	},
})
