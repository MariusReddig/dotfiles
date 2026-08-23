{
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.zsh = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          zsh = self'.packages.zsh;
        })
      ];
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        history.append = true;
        history.size = 10000;
      };
    }
  );
  perSystem =
    {
      pkgs,
      lib,
      self',
      hostname,
      ...
    }:
    {
      packages = {
        zsh = let
        flakeLocation = builtins.getEnv "PWD"
        in
        inputs.wrappers.wrappers.zsh.wrap {
          inherit pkgs;
          runtimePkgs = with pkgs; [ fzf ];

          dirHashes = {
            download = "$HOME/Downloads/";
            documents = "$HOME/Documents";
            pictures = "$HOME/Pictures/";
            config = "$HOME/.config/";
            videos = "$HOME/Videos/";
            music = "$HOME/Music/";
            git = "$HOME/git/";
            notes = "$HOME/notes/";
          };

          zshAliases = {
            ll = "ls -l";
            la = "ls -la";
            nixos-update = "sudo nixos-rebuild switch --flake $HOME/nix#${hostname}";
            nixos-build = "sudo nixos-rebuild build --flake $HOME/nix#${hostname}";
            nixos-test = "sudo nixos-rebuild test --flake $HOME/nix#${hostname}";
            nixos-cleanup = "sudo nix-collect-garbage -d; sudo nix-store --optimise -v";
            v = lib.getExe self'.packages.nvim;
            ts = "${lib.getExe self'.packages.tmux} source ~/.config/tmux/tmux.conf";
            spf = lib.getExe self'.package.superfile;
            nsh = "nix-shell -p"
            nrs = "(cd ${flakeLocation} && sudo nixos-rebuild switch --impure --flake .)"
          };

          initContent = ''
            export PATH="$HOME/.local/bin:$PATH"
            eval "$(direnv hook zsh)"
          '';

          oh-my-zsh = {
            enable = true;
            plugins = [
              "git"
              "bun"
            ];
            theme = "robbyrussell";
          };
        };
      };
    };
}
