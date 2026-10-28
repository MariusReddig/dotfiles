local dap = require("dap")
local dapvtext = require("nvim-dap-virtual-text").setup()

dap.adapters.lldb = {
    type = "executable",
    command = "lldb-dap",
    name = "lldb",
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = "${workspaceFolder}/build/main",
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        preLaunchTask = function()
            local configure_cmd = "make configure"
            local build_cmd = "make build"
            local success

            success = os.execute(configure_cmd .. " && " .. build_cmd)

            if success then
                vim.notify("✓ CMake build successful", vim.log.levels.INFO)
                return true
            else
                vim.notify("✗ CMake build failed", vim.log.levels.ERROR)
                return false
            end
        end,
    },
}

dap.configurations.c = dap.configurations.cpp
