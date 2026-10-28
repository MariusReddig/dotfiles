local conform = require("conform")
conform.setup({
    -- Format on save configuration
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true, -- Use LSP formatters as fallback
        async = false,
    },

    -- Formatters by file type
    formatters_by_ft = {
        lua = { "stylua" },
        cmake = { "cmake_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        nix = { "nixfmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        java = { "clang-format" },
        sql = { "sqlfluff" },
    },

    -- Custom formatter configurations
    formatters = {
        stylua = {
            prepend_args = {
                "--config-path",
                vim.fn.expand("~/nix/home/nvim/config/lua/config/stylua.toml"),
            },
        },
        cmake_format = {
            prepend_args = {
                "-c",
                vim.fn.expand("~/nix/home/nvim/config/lua/config/cmake.json"),
            },
        },
    },
})
