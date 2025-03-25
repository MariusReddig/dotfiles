require("nvim-treesitter.configs").setup({
	ensure_installed = {},
	auto_install = true,
	parser_install_dir = vim.fn.stdpath("data") .. "treesitter-parsers", -- Use a writable direct
	highlight = {
		enable = true,
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
	},
  indent = {
    enable = true,
  },
})
