-- vim: nofixendofline noendofline noeol:
require("snacks").setup({
  dashboard = {
    -- enable = true;
    width = 70,
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File",  action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files",  action = ":lua Snacks.dashboard.pick('oldfiles')" },
        { icon = " ", key = "c", desc = "Config",  action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = " ", key = "i", desc = "Nix Config",  action = ":cd ~/nix/ | lua Snacks.dashboard.pick('files')"},
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        { icon = " ", key = "q", desc = "Quit",  action = ":qa" },
      },
    header ="                                                                   \n"..
            "      ████ ██████           █████      ██                    \n"..
            "     ███████████             █████                            \n"..
            "     █████████ ███████████████████ ███   ███████████  \n"..
            "    █████████  ███    █████████████ █████ ██████████████  \n"..
            "   █████████ ██████████ █████████ █████ █████ ████ █████  \n"..
            " ███████████ ███    ███ █████████ █████ █████ ████ █████ \n"..
            "██████  █████████████████████ ████ █████ █████ ████ ██████\n",
    },
    formats = {
      key = { "" },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "terminal", cmd = "colorscript -e square", pane = 2, height = 5, padding = 1,},
      { section = "recent_files", icon = " ", title = "Recent Files", pane = 1, indent = 2, padding = 1 },
      { section = "projects",     icon = " ", title = "Projects",     pane = 1, indent = 2, padding = 1 },
      function()
        local in_git = Snacks.git.get_root() ~= nil
        local cmds = {
          {
            title = "Notifications",
            cmd = "gh-notify -s -a -n5",
            icon = " ",
            height = 5,
            enabled = true,
          },
          {
            title = "Open Issues",
            cmd = "gh issue list -L 3",
            icon = " ",
            height = 7,
          },
          {
            icon = " ",
            title = "Open PRs",
            cmd = "gh pr list -L 3",
            height = 7,
          },
          {
            icon = " ",
            title = "Git Status",
            cmd = "hub --no-pager diff --stat -B -M -C",
            height = 10,
          },
        }
      return vim.tbl_map(function(cmd)
          return vim.tbl_extend("force", {
            pane = 2,
            section = "terminal",
            enabled = in_git,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          }, cmd)
        end, cmds)
      end,
    },
  },
  git = {
    enable = true;
  }
})