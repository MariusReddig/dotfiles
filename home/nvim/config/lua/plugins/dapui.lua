local dap = require("dap")
local dapui = require("dapui")
local wk = require("which-key")
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
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 0.25,
            position = "left",
        },
        {
            elements = {
                { id = "repl", size = 0.5 },
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

-- Automatic keybind registration on DAP events
wk.register({
    d = {
        t = { dapui.toggle, "Toggle DAP UI" },
        c = { dap.continue, "Continue" },
        o = { dap.step_over, "Step Over" },
        i = { dap.step_into, "Step Into" },
        u = { dap.step_out, "Step Out" },
        b = { dap.toggle_breakpoint, "Toggle Breakpoint" },
        e = {
            function()
                require("dapui").eval()
            end,
            "Evaluate",
        },
        x = { dap.terminate, "Terminate" },
        r = { dap.repl.open, "Open REPL" },
    },
}, {
    prefix = "<leader>",
    mode = "n",
})
