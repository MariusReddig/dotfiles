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
	d = {
		name = "Diagnostics",
		d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show Line Diagnostics" }, -- Show diagnostics in a floating window
		n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" }, -- Jump to the next diagnostic
		p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" }, -- Jump to the previous diagnostic
		l = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Show Diagnostics in Location List" }, -- Open diagnostics in the location list
	},
	c = {
		name = "Code Actions",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" }, -- Trigger code actions
		f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format Buffer" }, -- Format the current buffer
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename Symbol" }, -- Rename symbol under cursor
		c = { "<cmd>!cargo check<cr>", "cargo check" },
	},
	g = {
		name = "Go To",
		d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" }, -- Go to definition
		D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to Declaration" }, -- Go to declaration
		i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to Implementation" }, -- Go to implementation
		r = { "<cmd>lua vim.lsp.buf.references()<cr>", "Go to References" }, -- Go to references
		t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to Type Definition" }, -- Go to type definition
	},
	K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show Documentation" }, -- Show documentation for symbol under cursor
}, { prefix = "<leader>" })
