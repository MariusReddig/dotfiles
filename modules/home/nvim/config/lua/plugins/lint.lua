require("lint").linters_by_ft = {
    text = { "codespell" },
    gitcommit = { "commitlint" },
    c = { "cppcheck" },
    cpp = { "cppcheck" },
    rst = { "rstcheck" },
    nix = { "statix" },
    lua = { "selene" },
    java = { "checkstyle", "pmd" },
    -- Add other diagnostics
}

-- Set up autocmd for diagnostics
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
