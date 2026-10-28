local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local wk = require("which-key")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local code_filetypes = {
  "lua",
  "nix",
  "c",
  "cpp",
  "objc",
  "objcpp",
  "java",
  "python",
  "rust",
  "go",
  "javascript",
  "typescript",
  "html",
  "css",
  "json",
  "yaml",
  "toml",
  "sh",
  "bash",
  "zsh",
  "vim",
  "vimwiki",
}

-- Format on save
local function setup_formatting(client, bufnr, name)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          async = false,
          bufnr = bufnr,
          filter = function(c)
            return c.name == name
          end,
        })
      end,
    })
  end
end

-- Buffer-local keymaps
local function bufmap(bufnr, keys, func, desc)
  vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
end

-- Check if buffer is a code file
local function is_code_file(bufnr)
  local ft = vim.bo[bufnr].filetype
  return vim.tbl_contains(code_filetypes, ft)
end

-- LSP attach function
local function on_attach(client, bufnr)
  -- Format on save
  setup_formatting(client, bufnr, client.name)

  -- User command
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
    vim.lsp.buf.format()
  end, {})

  -- Only add LSP keymaps for code files
  if is_code_file(bufnr) then
    -- LSP keymaps (which-key auto-detects them from the 'desc' parameter)
    bufmap(bufnr, "<localleader>r", vim.lsp.buf.rename, "Rename")
    bufmap(bufnr, "<localleader>a", vim.lsp.buf.code_action, "Code Action")
    bufmap(bufnr, "<localleader>f", function()
      vim.lsp.buf.format()
    end, "Format")

    bufmap(bufnr, "gd", vim.lsp.buf.definition, "Go to Definition")
    bufmap(bufnr, "gD", vim.lsp.buf.declaration, "Go to Declaration")
    bufmap(bufnr, "gI", vim.lsp.buf.implementation, "Go to Implementation")
    bufmap(bufnr, "gr", require("telescope.builtin").lsp_references, "Go to References")
    bufmap(bufnr, "gt", vim.lsp.buf.type_definition, "Go to Type Definition")

    bufmap(bufnr, "K", vim.lsp.buf.hover, "Hover Documentation")

    bufmap(bufnr, "<localleader>s", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
    bufmap(bufnr, "<localleader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

    -- Only need this to group LSP keymaps under <localleader>
    wk.add({ { "<localleader>", group = "LSP", buffer = bufnr } })
  end
end

-- ============================================================================
-- LSP Server Configurations
-- ============================================================================

-- Lua Language Server (with Hyprland stubs)
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".git" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim", "hl" },
        disable = { "lowercase-global" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          ["/run/current-system/usr/share/hypr/stubs"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Nix
vim.lsp.config("nil_ls", {
  cmd = { "nil" },
  filetypes = { "nix" },
  capabilities = capabilities,
  on_attach = on_attach,
})

-- C/C++
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--completion-style=detailed",
    "--compile-commands-dir=build",
    "--function-arg-placeholders",
    "--limit-results=0",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)

    -- Clangd-specific keymap (only for code files)
    if is_code_file(bufnr) then
      vim.keymap.set("n", "<localleader>h", "<cmd>ClangdSwitchSourceHeader<cr>", {
        buffer = bufnr,
        desc = "Switch Source/Header",
      })
      -- No wk.add needed! which-key auto-detects it
    end

    vim.lsp.inlay_hint.enable(true)
  end,
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
})

-- Java
vim.lsp.config("jdtls", {
  cmd = { "jdtls" },
  filetypes = { "java" },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      update_in_insert = false,
    })
  end,
})

-- ============================================================================
-- Enable LSP Servers
-- ============================================================================

vim.lsp.enable("lua_ls")
vim.lsp.enable("nil_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("jdtls")
