local actions = require("telescope.actions")
local telescope = require("telescope")
local wk = require("which-key")

telescope.setup({
  defaults = {
    -- Default configuration for telescope
    mappings = {
      i = {
        -- Map keys in insert mode
        ["<C-j>"] = actions.move_selection_next,                                   -- Next item
        ["<C-k>"] = actions.move_selection_previous,                               -- Previous item
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,         -- Send to quickfix list
        ["<Esc>"] = actions.close,                                                 -- Close telescope
      },
      n = {
        -- Map keys in normal mode
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden", -- Include hidden files
      "--glob=!.git/", -- Ignore .git directory
    },
    file_ignore_patterns = { "node_modules", ".git", "dist", "build" }, -- Ignore these files/dirs
    prompt_prefix = "🔍 ", -- Custom prompt prefix
    selection_caret = " ", -- Custom selection caret
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    path_display = { "truncate" },                 -- How file paths are displayed
    winblend = 0,                                  -- Transparency for the floating window
    border = {},                                   -- Border style for the floating window
    color_devicons = true,                         -- Enable color for file icons
    set_env = { ["COLORTERM"] = "truecolor" },     -- Enable truecolor support
  },
  pickers = {
    -- Custom configuration for built-in pickers
    find_files = {
      hidden = true,           -- Include hidden files
      no_ignore = false,       -- Respect .gitignore
    },
    live_grep = {
      only_sort_text = true,       -- Only sort by text, not file path
    },
    buffers = {
      sort_lastused = true,       -- Sort buffers by last used
      theme = "dropdown",         -- Use dropdown theme for buffers
    },
  },
  extensions = {
    -- Configuration for telescope extensions
    ["ui-select"] = {
      theme = "dropdown",       -- Use dropdown theme for ui-select
    },
    fzf = {
      fuzzy = true,                         -- false will only do exact matching
      override_generic_sorter = true,       -- override the generic sorter
      override_file_sorter = true,          -- override the file sorter
      case_mode = "smart_case",             -- or "ignore_case" or "respect_case"
    },
  },
})

-- Load telescope extensions
telescope.load_extension("ui-select")
telescope.load_extension("fzf")

-- Set Keybinds
wk.add({
  { "<leader>f",  group = "Telescope" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find Files" },
  { "<leader>fF", "<cmd>Telescope find_files cwd=~<cr>",          desc = "Find Files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live Grep" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Find Buffers" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Find Help Tags" },
  { "<leader>fs", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in Buffer" },
  { "<leader>fr", "<cmd>Telescope resume<cr>",                    desc = "Resume Last Search" },
  { "<leader>fu", "<cmd>Telescope ui-select<cr>",                 desc = "UI Select" },
})
