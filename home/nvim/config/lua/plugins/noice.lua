require("noice").setup({
	-- You can customize the configuration here
	cmdline = {
		enabled = true, -- Enable the cmdline UI
		view = "cmdline_popup", -- Use the popup view for the cmdline
		opts = {}, -- Additional options for the cmdline view
	},
	messages = {
		enabled = true, -- Enable messages UI
		view = "mini", -- Use the notify view for messages
		opts = {}, -- Additional options for the messages view
	},
	popupmenu = {
		enabled = true, -- Enable the popupmenu UI
		backend = "cmp", -- Use nui as the backend for the popupmenu
	},
	notify = {
		enabled = true, -- Enable notifications
		view = "notify", -- Use the notify view for notifications
	},
	lsp = {
		progress = {
			enabled = true, -- Enable LSP progress notifications
			view = "mini", -- Use the mini view for LSP progress
		},
		hover = {
			enabled = true, -- Enable LSP hover documentation
			view = "popup", -- Use the popup view for hover documentation
		},
		signature = {
			enabled = true, -- Enable LSP signature help
			view = "popup", -- Use the popup view for signature help
		},
	},
	presets = {
		bottom_search = true, -- Use a bottom search bar
		command_palette = true, -- Enable the command palette
		long_message_to_split = true, -- Split long messages into multiple lines
		lsp_doc_border = true, -- Add a border to LSP documentation
	},
})
