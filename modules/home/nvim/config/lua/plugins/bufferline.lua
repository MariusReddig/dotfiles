require("bufferline").setup({})

require("which-key").add({
  { "<leader>b",  group = "Buffer management" },
  { "<leader>bb", "<cmd>bnext<cr>",           desc = "go to the next buffer" },
  { "<leader>bB", "<cmd>bprev<cr>",           desc = "go to the previous buffer" },
  { "<leader>b0", "<cmd>b 10<cr>",            desc = "go to buffer 10" },
  { "<leader>bd", "<cmd>bp | bd#<cr>",        desc = "Delete window" },
})
