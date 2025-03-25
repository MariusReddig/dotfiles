require("nvim-dap-virtual-text").setup()
require("dapui").setup()
require("dap").adapters.lldb = {
	type = "executable",
	command = "lldb-dap",
	name = "lldb",
}

