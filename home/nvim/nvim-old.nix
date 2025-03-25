{ config, pkgs-unstable, lib, ... }:
{
  home.packages = with pkgs-unstable; [
    ripgrep
    nil
    lua-language-server
    tree-sitter

    ### Formater and Diagnostics
    rustup # Rust package manager (required for some tools)
    clang-tools
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

    plugins = with pkgs-unstable.vimPlugins; [

      ### LSP (Language Server Protocol) ###
      cmp-nvim-lsp # LSP source for nvim-cmp
      cmp-buffer # Buffer source for nvim-cmp
      cmp-path # Path source for nvim-cmp
      cmp-cmdline # Command-line source for nvim-cmp
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/lsp.lua;
      }
      {
        plugin = nvim-cmp; # Autocompletion plugin
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/cmp.lua;
      }
      {
        plugin = null-ls-nvim; # Use non-LSP tools (formatters, linters) with LSP
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/null-ls.lua;
      }

      ### Snippets ###
      luasnip # Snippet engine
      friendly-snippets # Predefined snippets for luasnip

      ### Syntax Highlighting ###
      {
        plugin = nvim-treesitter.withAllGrammars; # Better syntax highlighting
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/treesitter.lua;
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
        config = builtins.readFile ./config/lua/plugins/neo-tree.lua;
      }
      {
        plugin = tokyonight-nvim; # Colorscheme
        type = "lua";
        config = "vim.cmd[[colorscheme tokyonight-moon]]";
      }
      {
        plugin = lualine-nvim; # Status line
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/lualine.lua;
      }
      {
        plugin = noice-nvim; # Improved UI for messages, cmdline, and popups
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/noice.lua;
      }
      {
        plugin = which-key-nvim; # Keybinding hints
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/which-key.lua;
      }
      trouble-nvim # Pretty diagnostics list
      mini-nvim # Minimal and fast UI utilities

      ### Tools and Utilities ###
      plenary-nvim # Dependency for telescope and other plugins
      telescope-ui-select-nvim
      {
        plugin = telescope-nvim; # Fuzzy finder
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/telescope.lua;
      }

      toggleterm-nvim # Toggleable terminal
      vim-sleuth # Automatically adjust settings (e.g., tabstop) based on file
      {
        plugin = snacks-nvim; # Utility functions for Neovim
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/snacks.lua;
      }
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./config/lua/core/options.lua}
      ${builtins.readFile ./config/lua/core/keybinds.lua}
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
