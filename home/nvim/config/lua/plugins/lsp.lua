local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require("lspconfig")
local wk = require("which-key")
local create_format_autocommand = function(client, bufnr, name)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    async = false,
                    bufnr = bufnr,
                    filter = function(client_filter)
                        return client_filter.name == name
                    end,
                })
            end,
        })
    end
end
local on_attach = function(_, bufnr)
    local bufmap = function(keys, func)
        vim.keymap.set("n", keys, func, { buffer = bufnr })
    end
    bufmap("<leader>cr", vim.lsp.buf.rename)
    bufmap("<leader>ca", vim.lsp.buf.code_action)

    -- Go-to
    bufmap("gd", vim.lsp.buf.definition)
    bufmap("gD", vim.lsp.buf.declaration)
    bufmap("gI", vim.lsp.buf.implementation)
    bufmap("gr", require("telescope.builtin").lsp_references)
    bufmap("<leader>gt", vim.lsp.buf.type_definition)
    bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
    bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)

    -- Documentation
    bufmap("K", vim.lsp.buf.hover)

    wk.add({
        { "<leader>g", group = "Go To" },
        { "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Go to Definition" },
        { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Go to Declaration" },
        { "<leader>gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Go to Implementation" },
        { "<leader>gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "Go to References" },
        { "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Go to Type Definition" },

        -- Documentation
        { "<leader>K", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Show Documentation" },
    })
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, {})
end

lspconfig.nil_ls.setup({ capabilities = capabilities })

-- Clang (cpp)

lspconfig.clangd.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        create_format_autocommand(client, bufnr, "clangd")
        vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = bufnr })
        vim.lsp.inlay_hint.enable(true)
    end,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--compile-commands-dir=build",
        "--function-arg-placeholders",
        "--limit-results=0",
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
})

-- Java
lspconfig.jdtls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- Auto-completion
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Diagnostic config
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = false,
        })
    end,
})
