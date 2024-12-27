{ lib, config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake ~/.config/nixos#default";
      v = "nvim";
      vv = "sudo nvim";
      sd = "shutdown 0";
    };
    histSize = 10000;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "bun"];
      theme = "robbyrussell";
    };
  };
}
