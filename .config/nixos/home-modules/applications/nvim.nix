{ config, pkgs, lib, ... }:
{
  options = {
    nvim.enable = lib.mkEnableOption "enable nvim module";
  };
  config = lib.mkIf config.nvim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    home.packages = with pkgs; [
      vimPlugins.fzfWrapper
      cargo
      gccgo14
      cmake
      lazygit
      vim
      bash
      ripgrep
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
