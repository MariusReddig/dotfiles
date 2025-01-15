{ lib, config, pkgs, ... }:
{
  options = {
    zsh.enable = lib.mkEnableOption "enable zsh module";
  };

  config = lib.mkIf config.zsh.enable {

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      history.append = true;
      history.size = 10000;

      dirHashes = {
        download = "$HOME/Downloads/";
        documents = "$HOME/Documents";
        pictures = "$HOME/Pictures/";
        config = "$HOME/.config/";
        videos = "$HOME/Videos/";
        music = "$HOME/Music/";
        git = "$HOME/git/";
      };

      shellAliases = {
        ll = "ls -l";
        la = "ls -la";
        nix-update = "sudo nixos-rebuild switch --flake ~/git/personal/dotfiles/.config/nixos#workstation";
        nix-build = "sudo nixos-rebuild build --flake ~/git/personal/dotfiles/.config/nixos#workstation";
        v = "nvim";
        vv = "sudo nvim";
        sd = "shutdown 0";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "bun" ];
        theme = "robbyrussell";
      };
    };

    home.packages = with pkgs; [
      zsh-powerlevel10k
    ];

    # users.users.${home.userName}.shell = pkgs.zsh;
  };
}
