require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "tokyonight-moon", -- Use the 'tokyonight' theme
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "NvimTree", "snacks" }, -- Disable Lualine for NvimTree and alpha
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			"diff",
			{
				"diagnostics",
				sources = { "nvim_lsp" }, -- Only show LSP diagnostics
				symbols = { error = " ", warn = " ", info = " ", hint = " " }, -- Custom icons
			},
		},
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { "buffers" }, -- Show open buffers in the tabline
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "tabs" }, -- Show tabs in the tabline
	},
	extensions = { "nvim-tree", "fugitive" }, -- Enable extensions for nvim-tree and fugitive
})
