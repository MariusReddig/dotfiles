local map = vim.keymap.set
local wk = require("which-key")

-- Window movement
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Window resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

wk.add({
  { "<leader>D",  group = "Diagnostics" },
  { "<leader>Dd", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Show Line Diagnostics" },
  { "<leader>Dn", "<cmd>lua vim.diagnostic.goto_next()<cr>",  desc = "Next Diagnostic" },
  { "<leader>Dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>",  desc = "Previous Diagnostic" },
  {
    "<leader>Dl",
    "<cmd>lua vim.diagnostic.setloclist()<cr>",
    desc = "Show Diagnostics in Location List",
  },
})
