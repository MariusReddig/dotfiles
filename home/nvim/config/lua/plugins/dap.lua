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
            local configure_cmd = "cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug"
            local build_cmd = "cmake --build build"
            local success

            if vim.fn.filereadable("shell.nix") == 1 then
                -- Correct syntax: nix-shell --run "command && command"
                success = os.execute("nix-shell --run '" .. configure_cmd .. " && " .. build_cmd .. "'")
            else
                success = os.execute(configure_cmd .. " && " .. build_cmd)
            end

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
dap.configurations.rust = dap.configurations.cpp
