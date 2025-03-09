{ config, pkgs, lib, ... }:
{
  options = {
        nvim.enable = lib.mkEnableOption "enable nvim module";
  };

  config = lib.mkIf config.nvim.enable {

    home.packages = with pkgs; [
      ripgrep
      nil
      fd
      lua-language-server
      lazygit
      wl-clipboard
      tree-sitter
      git

      ### Formater and Diagnostics
      rust-analyzer # LSP for Rust
      cargo # Rust package manager (required for some tools)
      clippy # Rust linter
      clang-tools
      rustfmt
      rustc
      nodejs
      textlint
      eslint
      nixpkgs-fmt
      clang-tools
      stylua
      statix
      cppcheck
      shellcheck
      shfmt
      luajitPackages.luacheck
      nodePackages.jsonlint
      nodePackages.prettier
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [

        ### LSP (Language Server Protocol) ###
        cmp-nvim-lsp # LSP source for nvim-cmp
        cmp-buffer # Buffer source for nvim-cmp
        cmp-path # Path source for nvim-cmp
        cmp-cmdline # Command-line source for nvim-cmp
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = builtins.readFile ./plugins/lsp.lua;
        }
        {
          plugin = nvim-cmp; # Autocompletion plugin
          type = "lua";
          config = builtins.readFile ./plugins/cmp.lua;
        }
        {
          plugin = null-ls-nvim; # Use non-LSP tools (formatters, linters) with LSP
          type = "lua";
          config = builtins.readFile ./plugins/null-ls.lua;
        }

        ### Snippets ###
        luasnip # Snippet engine
        friendly-snippets # Predefined snippets for luasnip

        ### Syntax Highlighting ###
        {
          plugin = nvim-treesitter.withAllGrammars; # Better syntax highlighting
          type = "lua";
          config = builtins.readFile ./plugins/treesitter.lua;
        }

        ### Formatting and Editing ###
        nvim-autopairs # Automatically close pairs (brackets, quotes, etc.)
        comment-nvim # Easy commenting
        vim-surround # Manipulate surroundings (brackets, quotes, etc.)
        vim-repeat # Repeat actions with `.`


        ### Git Integration ###
        gitsigns-nvim # Git signs in the gutter
        vim-fugitive # Git commands in Vim

        ### UI and Appearance ###
        nvim-web-devicons # Icons for various plugins
        {
          plugin = neo-tree-nvim; # File explorer
          type = "lua";
          config = builtins.readFile ./plugins/neo-tree.lua;
        }
        {
          plugin = tokyonight-nvim; # Colorscheme
          type = "lua";
          config = "vim.cmd[[colorscheme tokyonight-moon]]";
        }
        {
          plugin = lualine-nvim; # Status line
          type = "lua";
          config = builtins.readFile ./plugins/lualine.lua;
        }
        {
          plugin = noice-nvim; # Improved UI for messages, cmdline, and popups
          type = "lua";
          config = builtins.readFile ./plugins/noice.lua;
        }
        {
          plugin = which-key-nvim; # Keybinding hints
          type = "lua";
          config = builtins.readFile ./plugins/which-key.lua;
        }
        trouble-nvim # Pretty diagnostics list
        mini-nvim # Minimal and fast UI utilities

        ### Tools and Utilities ###
        plenary-nvim # Dependency for telescope and other plugins
        telescope-ui-select-nvim
        {
          plugin = telescope-nvim; # Fuzzy finder
          type = "lua";
          config = builtins.readFile ./plugins/telescope.lua;
        }

        toggleterm-nvim # Toggleable terminal
        vim-sleuth # Automatically adjust settings (e.g., tabstop) based on file
        {
          plugin = snacks-nvim; # Utility functions for Neovim
          type = "lua";
          config = builtins.readFile ./plugins/snacks.lua;
        }
      ];
      extraLuaConfig = ''
        ${builtins.readFile ./config/options.lua}
        ${builtins.readFile ./config/keybinds.lua}
      '';
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
