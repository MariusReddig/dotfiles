{ config, pkgs, lib, ... }:
{
  options = {
    nvim.enable = lib.mkEnableOption "enable nvim module";
  };

  config = lib.mkIf config.nvim.enable {

    home.packages = with pkgs; [
      nodejs
      python3
      rustc
      cargo
      go
      gopls
      nil
      clang-tools
      shellcheck
      shfmt
      nixpkgs-fmt
      statix
      cppcheck
      rustfmt
      clippy
      ripgrep
      fd
      fzf
      fortune
      lazygit
      wl-clipboard
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        # Core plugins
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        luasnip
        friendly-snippets
        telescope-nvim
        plenary-nvim
        nvim-treesitter.withAllGrammars
        nvim-autopairs
        comment-nvim
        gitsigns-nvim
        lualine-nvim
        nvim-web-devicons
        vim-fugitive
        vim-surround
        vim-repeat
        vim-sleuth

        # UI and tools
        toggleterm-nvim
        tokyonight-nvim
        noice-nvim
        which-key-nvim
        snacks-nvim # Replace alpha-nvim with snacker.nvim
        mini-nvim
        trouble-nvim

        # LSP and formatting
        null-ls-nvim

        # File tree
        nvim-neo-tree

        # Git integration
        lazygit-nvim
      ];

      extraConfig = ''
        " Basic settings
        set number
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smartindent
        set termguicolors

        " Set leader key to space
        let mapleader = "\<Space>"

        " Enable Tokyo Night theme
        lua << EOF
        vim.cmd[[colorscheme tokyonight-moon]]
        EOF

        " Enable LSP
        lua << EOF
        local lspconfig = require('lspconfig')
        local cmp = require('cmp')
        local null_ls = require('null-ls')

        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.nixpkgs_fmt,
            null_ls.builtins.diagnostics.statix,
            null_ls.builtins.formatting.clang_format.with({
              command = "${pkgs.clang-tools}/bin/clang-format",
            }),
            null_ls.builtins.diagnostics.cppcheck,
            null_ls.builtins.formatting.shfmt,
            null_ls.builtins.diagnostics.shellcheck,
            null_ls.builtins.formatting.rustfmt,
          },
        })

        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = {
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-CR>'] = cmp.mapping.confirm({ select = true }),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
              i = cmp.mapping.abort(),
              c = cmp.mapping.close(),
            }),
          },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'nvim_lua' },
          })
        })

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        lspconfig.nil_ls.setup { capabilities = capabilities }
        lspconfig.clangd.setup { capabilities = capabilities }
        lspconfig.bashls.setup { capabilities = capabilities }
        lspconfig.rust_analyzer.setup {
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        }

        local servers = { 'gopls', 'pyright' }
        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup { capabilities = capabilities }
        end
        EOF

        " Telescope keybindings
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>fh <cmd>Telescope help_tags<cr>

        " Lualine setup
        lua << EOF
        require('lualine').setup {
          options = {
            theme = 'tokyonight',
          },
        }
        EOF

        " Configure toggleterm.nvim
        lua << EOF
        require('toggleterm').setup({
          open_mapping = [[<M-2>]], -- <leader>t to toggle the terminal
          direction = 'float',          -- Open as a floating window
          float_opts = {
            border = 'curved',          -- Border style for the floating window
            --width = 80,                 -- Width of the floating window
            --height = 20,                -- Height of the floating window
          },
        })
        EOF

        " Auto-format on save
        augroup FormatOnSave
          autocmd!
          autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
        augroup END

        " Configure noice.nvim
        lua << EOF
        require('noice').setup({
          cmdline = { enabled = true },
          messages = { enabled = true },
          popupmenu = { enabled = true },
        })
        EOF

        " Configure which-key.nvim
        lua << EOF
        require('which-key').setup({})
        EOF

        " Configure snacker.nvim (dashboard)
        lua << EOF
        require('snacker').setup({
          header = {
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
            [[                                                                       ]],
            [[                                                                       ]],
          },
          buttons = {
            { "n", "  New file", ":ene <BAR> startinsert <CR>" },
            { "f", "󰍉  Find file", ":Telescope find_files hidden=true no-ignore=false<CR>" },
            { "r", "  Recent", ":Telescope oldfiles<CR>" },
            { "c", "  Nvim config", ":cd $HOME/.config/nvim/ | Telescope find_files<CR>" },
            { "N", "  Nix config", ":cd $HOME/.config/nix/ | Telescope find_files<CR>" },
            { "h", "󰜕  Hyprland Config", ":cd $HOME/.config/hypr/ | Telescope find_files<CR>" },
            { "q", "  Quit NVIM", ":qa<CR>" },
          },
        })
        EOF

        " Configure all mini.nvim modules
        lua << EOF
        require('mini.ai').setup({})
        require('mini.align').setup({})
        require('mini.comment').setup({})
        require('mini.completion').setup({})
        require('mini.cursorword').setup({})
        require('mini.indentscope').setup({})
        require('mini.jump').setup({})
        require('mini.pairs').setup({})
        require('mini.surround').setup({})
        require('mini.tabline').setup({})
        require('mini.trailspace').setup({})
        EOF

        " Configure trouble.nvim
        lua << EOF
        require('trouble').setup({})
        EOF

        " Keybindings for trouble.nvim
        nnoremap <leader>xx <cmd>TroubleToggle<cr>
        nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
        nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
        nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
        nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>

        " Configure lazygit.nvim
        lua << EOF
        require('lazygit').setup({
          floating_window_winblend = 10,
          floating_window_scaling_factor = 0.9,
          use_neovim_remote = true,
        })
        EOF

        " Keybinding for lazygit
        nnoremap <leader>gg <cmd>LazyGit<cr>

        " Configure nvim-neo-tree
        lua << EOF
        require('neo-tree').setup({
          close_if_last_window = true,
          popup_border_style = "rounded",
          enable_git_status = true,
          enable_diagnostics = true,
          default_component_configs = {
            indent = {
              indent_size = 2,
              padding = 1,
              with_markers = true,
              indent_marker = "│",
              last_indent_marker = "└",
              highlight = "NeoTreeIndentMarker",
            },
            icon = {
              folder_closed = "",
              folder_open = "",
              folder_empty = "",
              default = "",
            },
            name = {
              trailing_slash = false,
              use_git_status_colors = true,
            },
          },
          window = {
            position = "left",
            width = 30,
          },
          filesystem = {
            filtered_items = {
              visible = false,
              hide_dotfiles = false,
              hide_gitignored = false,
            },
          },
        })
        EOF

        " Keybinding for nvim-neo-tree
        nnoremap <leader>e <cmd>NeoTreeFocusToggle<cr>
      '';
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
