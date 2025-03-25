{ lib, config, pkgs, ... }:
{
  options = {
    zsh.enable = lib.mkEnableOption "enable zsh module";
  };

  config = lib.mkIf config.zsh.enable {

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

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
        nix-update = "sudo nixos-rebuild switch --flake $HOME/nix#desktop";
        nix-build = "sudo nixos-rebuild build --flake $HOME/nix#desktop";
        v = "nvim";
        vv = "sudo nvim";
        sd = "shutdown 0";
        ts = "tmux source ~/.config/tmux/tmux.conf";
      };

      initExtra = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

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
