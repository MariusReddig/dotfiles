-- dap.lua
local dap = require("dap")
local dapui = require("dapui")
local wk = require("which-key")

-- Setup DAP UI
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      size = 0.25,
      position = "left",
    },
    {
      elements = {
        { id = "repl",    size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 0.25,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
})

-- DAP keymaps with <localleader>d prefix
wk.add({
  { "<localleader>d",  group = "Debug" },
  { "<localleader>dt", dapui.toggle,          desc = "Toggle DAP UI" },
  { "<localleader>dc", dap.continue,          desc = "Continue" },
  { "<localleader>do", dap.step_over,         desc = "Step Over" },
  { "<localleader>di", dap.step_into,         desc = "Step Into" },
  { "<localleader>du", dap.step_out,          desc = "Step Out" },
  { "<localleader>db", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
  {
    "<localleader>de",
    function()
      require("dapui").eval()
    end,
    desc = "Evaluate",
  },
  { "<localleader>dx", dap.terminate, desc = "Terminate" },
  { "<localleader>dr", dap.repl.open, desc = "Open REPL" },
})
