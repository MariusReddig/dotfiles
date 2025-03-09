local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- Code Actions
		null_ls.builtins.code_actions.eslint,		-- JavaScript/TypeScript
		null_ls.builtins.code_actions.cargo_check,	-- Rust
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.refactoring,

		-- Diagnostics (Linters)
		null_ls.builtins.diagnostics.cppcheck,			-- C/C++
		null_ls.builtins.diagnostics.jsonlint.with({	-- JSON/JSONC
			filetypes = { "json", "jsonc" },
		}),
		null_ls.builtins.diagnostics.luacheck,		-- Lua
		null_ls.builtins.diagnostics.shellcheck,	-- Shell scripts
		null_ls.builtins.diagnostics.statix,		-- Nix
		null_ls.builtins.diagnostics.textlint,		-- Text and Markdown
		null_ls.builtins.diagnostics.clippy,		-- Rust
		null_ls.builtins.diagnostics.trailing_space, -- Trailing whitespace
		null_ls.builtins.diagnostics.misspell, -- Spell-checking
		null_ls.builtins.diagnostics.todo_comments, -- TODO comments

		-- Formatting
		null_ls.builtins.formatting.clang_format.with({ -- C/C++
			command = "clang-format",
		}),
		null_ls.builtins.formatting.nixpkgs_fmt,	-- Nix
		null_ls.builtins.formatting.prettier.with({ -- JSON/JSONC
			filetypes = { "json", "jsonc" },
			extra_args = { "--parser", "json" },
		}),
		null_ls.builtins.formatting.rustfmt,	-- Rust
		null_ls.builtins.formatting.shfmt,		-- Shell scripts
		null_ls.builtins.formatting.stylua,		-- Lua

		-- Hover
		null_ls.builtins.hover.dictionary, -- Dictionary hover
		null_ls.builtins.hover.printenv, -- Environment variable hover
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- Use vim.lsp.buf.format for Neovim 0.8+
					vim.lsp.buf.format({
						async = false,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
require("lspconfig")["null-ls"].setup({})
