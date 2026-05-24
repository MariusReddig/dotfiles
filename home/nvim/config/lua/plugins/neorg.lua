require("neorg").setup({
    lazy = false,
    version = "*",
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/notes",
                },
                default_workspace = "notes",
            },
        },
    },
})

-- These should be outside the setup call
vim.wo.foldlevel = 99
vim.wo.conceallevel = 2
