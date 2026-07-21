-- treesitter.lua - Simplified version
require("nvim-treesitter").install({
  "lua",
  "python",
  "cpp",
  "rust",
  "markdown",
  "nix",
  "bash",
  "json",
  "toml",
  "yaml",
  "vim",
  "norg",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "lua",
    "python",
    "cpp",
    "rust",
    "markdown",
    "nix",
    "bash",
    "json",
    "toml",
    "yaml",
    "vim",
    "norg",
  },
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})
require("which-key").add({ { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle File Explorer" } })
