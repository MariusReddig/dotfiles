local map = vim.keymap.set
local wk = require("which-key")

-- Window movement
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

wk.register({
	f = {
		name = "Telescope",
		f = { "<cmd>Telescope find_files<cr>", "Find Files" },
		F = { "<cmd>Telescope find_files cwd=~<cr>", "Find Files" },
		g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
		b = { "<cmd>Telescope buffers<cr>", "Find Buffers" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help Tags" },
		s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search in Buffer" },
		r = { "<cmd>Telescope resume<cr>", "Resume Last Search" },
		u = { "<cmd>Telescope ui-select<cr>", "UI Select" },
	},
	w = {
		name = "Window management",
		s = { "<C-W>s", "Split window right" },
		v = { "<C-W>v", "Split window below" },
		d = { "<C-W>c", "Delete window" },
	},
	e = { "<cmd>Neotree toggle<cr>", "Toggle File Explorer" }, -- Toggle Neotree
}, { prefix = "<leader>" })
