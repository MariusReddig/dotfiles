require("neo-tree").setup({
	filesystem = {
		bind_to_cwd = false,
		follow_current_file = { enabled = true },
		window = {
			mappings = {
				position = "left", -- Position the NeoTree window on the left side
				width = 20, -- Set the width of the NeoTree window
				["<space>"] = "none",
				["l"] = "open",
				["h"] = "close_node",
				["<S-cr>"] = "open_tabnew",
			},
		},
	},
})
