{ lib, config, pkgs, host, ... }:
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
        nixos-update = "sudo nixos-rebuild switch --flake $HOME/nix#${host}";
        nixos-build = "sudo nixos-rebuild build --flake $HOME/nix${host}";
        v = "nvim";
        vv = "sudo nvim";
        sd = "shutdown 0";
        ts = "tmux source ~/.config/tmux/tmux.conf";
      };

      initContent = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "bun" ];
        theme = "robbyrussell";
      };
    };

    # users.users.${home.userName}.shell = pkgs.zsh;
  };
}
