require("neo-tree").setup({
	filesystem = {
    bind_to_cwd = false,
		follow_current_file = { enabled = true },
    window = {
      width = 30,
      auto_expand_width = false,
      mappings = {
				["<space>"] = "none",
				["l"] = "open",
				["h"] = "close_node",
				["<S-cr>"] = "open_tabnew",
			}, 
    },
    filtered_times= {
      visible = true,
    },
	},
})
