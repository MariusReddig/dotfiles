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
  { "<leader>f", group = "Telescope" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>"                ,desc = "Find Files"         },
  { "<leader>fF", "<cmd>Telescope find_files cwd=~<cr>"          ,desc = "Find Files"         },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>"                 ,desc = "Live Grep"          },
  { "<leader>fb", "<cmd>Telescope buffers<cr>"                   ,desc = "Find Buffers"       },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>"                 ,desc = "Find Help Tags"     },
  { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>" ,desc = "Search in Buffer"   },
  { "<leader>fr", "<cmd>Telescope resume<cr>"                    ,desc = "Resume Last Search" },
  { "<leader>fu", "<cmd>Telescope ui-select<cr>"                 ,desc = "UI Select"          },

  { "<leader>w", group = "Window management" },
  { "<leader>ws", proxy = "<C-W>s"    ,desc = "Split window right" },
  { "<leader>wv", proxy = "<C-W>v"    ,desc = "Split window below" },
  { "<leader>wd", "<cmd>bp | bd#<cr>" ,desc = "Delete window"      },

  -- Neotree
  { "<leader>e", "<cmd>Neotree toggle<cr>" ,desc = "Toggle File Explorer" },

  { "<leader>d", group = "Diagnostics" },
  { "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<cr>" ,desc = "Show Line Diagnostics"             },
  { "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>"  ,desc = "Next Diagnostic"                   },
  { "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>"  ,desc = "Previous Diagnostic"               },
  { "<leader>dl", "<cmd>lua vim.diagnostic.setloclist()<cr>" ,desc = "Show Diagnostics in Location List" },

  { "<leader>c", group = "Diagnostics" },
  { "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>"            ,desc = "Code Action"   },
  { "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>" ,desc = "Format Buffer" },
  { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>"                 ,desc = "Rename Symbol" },
})

