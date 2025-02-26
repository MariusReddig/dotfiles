local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- Existing sources
		null_ls.builtins.formatting.nixpkgs_fmt,
		null_ls.builtins.diagnostics.statix,
		null_ls.builtins.diagnostics.cppcheck,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.diagnostics.luacheck,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "json", "jsonc" },
			extra_args = { "--parser", "json" },
		}),
		null_ls.builtins.diagnostics.jsonlint.with({
			filetypes = { "json", "jsonc" },
		}),
		null_ls.builtins.formatting.clang_format.with({
			command = "clang-format",
		}),
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })

			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				group = augroup,
				callback = function()
					vim.lsp.buf.format({
						async = false,
						bufnr = bufnr,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
