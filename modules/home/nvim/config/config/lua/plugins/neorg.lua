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
    ["core.keybinds"] = {
      config = {
        default_keybinds = false,
      },
    },
  },
})

-- These should be outside the setup call
vim.wo.foldlevel = 99
vim.wo.conceallevel = 2

-- Mapping
vim.api.nvim_create_autocmd("FileType", {
  pattern = "norg",
  callback = function()
    -- Normal mode
    vim.keymap.set("n", "<LocalLeader>nn", "<Plug>(neorg.dirman.new-note)", { buffer = true, desc = "New Note" })
    vim.keymap.set("n", ">>", "<Plug>(neorg.promo.promote)", { buffer = true, desc = "Promote Item with Children" })
    vim.keymap.set("n", "<<", "<Plug>(neorg.promo.demote)", { buffer = true, desc = "Demote Item with Children" })
    vim.keymap.set("n", ">.", "<Plug>(neorg.promo.promote.nested)", { buffer = true, desc = "Promote Item Only" })
    vim.keymap.set("n", "<.", "<Plug>(neorg.promo.demote.nested)", { buffer = true, desc = "Demote Item Only" })
    vim.keymap.set(
      "n",
      "<LocalLeader>nlt",
      "<Plug>(neorg.pivot.list.toggle)",
      { buffer = true, desc = "Toggle List Type" }
    )
    vim.keymap.set(
      "n",
      "<LocalLeader>nli",
      "<Plug>(neorg.pivot.list.invert)",
      { buffer = true, desc = "Invert List Type" }
    )
    vim.keymap.set(
      "n",
      "<localleader>ntd",
      "<Plug>(neorg.qol.todo_items.todo.task_done)",
      { buffer = true, desc = "Mark Task Done" }
    )
    vim.keymap.set(
      "n",
      "<LocalLeader>ntu",
      "<Plug>(neorg.qol.todo_items.todo.task_undone)",
      { buffer = true, desc = "Mark Task Undone" }
    )
    vim.keymap.set("n", "<leader>t", ":Neorg toc<CR>", { buffer = true, desc = "Generate TOC" })
    vim.keymap.set("n", "<CR>", "<Plug>(neorg.esupports.hop.hop-link)", { buffer = true, desc = "Jump to Link" })

    -- Insert mode
    vim.keymap.set("i", "<C-t>", "<Plug>(neorg.promo.promote)", { buffer = true, desc = "Promote Item (Insert)" })
    vim.keymap.set("i", "<C-d>", "<Plug>(neorg.promo.demote)", { buffer = true, desc = "Demote Item (Insert)" })
    vim.keymap.set(
      "i",
      "<M-CR>",
      "<Plug>(neorg.itero.next-iteration)",
      { buffer = true, desc = "Continue List Item" }
    )

    -- Visual mode
    vim.keymap.set("v", ">>", "<Plug>(neorg.promo.promote.range)", { buffer = true, desc = "Promote Range" })
    vim.keymap.set("v", "<<", "<Plug>(neorg.promo.demote.range)", { buffer = true, desc = "Demote Range" })
  end,
})
