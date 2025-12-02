{ config, username, pkgs, ... }: {
  home.packages = (with pkgs; [
    wl-clipboard
    tree-sitter
    ripgrep
    fd
    lazygit
    lua-language-server
    nil
    gnumake42

    # llvm
    bear
    clang
    lldb_21
    llvmPackages_19.llvm-manpages
    llvmPackages_19.clang-manpages

    #lsp
    nodejs
    rustup
    nil
    clang-tools
    lua-language-server

    #markdown-live-preview
    glow

    #formatters
    stylua
    cmake-format
    nixfmt-classic
    nodePackages.prettier

    #linters
    selene
    codespell
    cppcheck
    rstcheck
    commitlint
    statix
  ]);

  stylix.targets.neovim.enable = false;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = (with pkgs.vimPlugins; [
      tokyonight-nvim
      neo-tree-nvim
      which-key-nvim
      nvim-web-devicons
      mini-icons
      mini-pairs
      nvim-treesitter.withAllGrammars
      bufferline-nvim
      lualine-nvim
      mini-surround
      mini-animate
      mini-indentscope
      noice-nvim
      nvim-lspconfig
      nvim-cmp
      telescope-nvim
      plenary-nvim
      telescope-ui-select-nvim
      telescope-fzf-native-nvim
      cmp-nvim-lsp # LSP source for nvim-cmp
      cmp-buffer # Buffer source for nvim-cmp
      cmp-path # Path source for nvim-cmp
      cmp-cmdline # Command-line source for nvim-cmp
      nvim-cmp
      luasnip # Snippet engine
      friendly-snippets # Predefined snippets for luasnip
      comment-nvim
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      cmp-dap
      nvim-colorizer-lua
      snacks-nvim
      lazy-nvim
      vimtex
      gitsigns-nvim
      vim-clang-format
      conform-nvim
      nvim-lint
      clangd_extensions-nvim
    ]);
  };

  home.activation.linkNvimFiles =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfr -T /home/${username}/nix/home/nvim/config/ ~/.config/nvim
    '';

  home.sessionVariables = { EDITOR = "nvim"; };
}
