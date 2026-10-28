{
  self,
  moduleWithSystem,
  ...
}:
{
  # System side: zsh has to be enabled system-wide to be a login shell
  flake.nixosModules.zsh = {
    programs.zsh.enable = true;
  };

  flake.homeModules.zsh = moduleWithSystem (
    {
      flakeLocation,
      ...
    }:
    { ... }:
    let
      modules = with self.homeModules; [ ];
    in
    {
      imports = modules;
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
          notes = "$HOME/notes/";
        };

        shellAliases = {
          ll = "ls -l";
          la = "ls -la";
          nixos-update =
            if flakeLocation != "" then
              "( cd ${flakeLocation} && sudo nixos-rebuild switch --impure --flake .)"
            else
              " echo 'Flake location not specified. Did you bild with --impure?'";
          nixos-build =
            if flakeLocation != "" then
              "nvim --cmd 'cd ${flakeLocation}'"
            else
              " echo 'Flake location not specified. Did you bild with --impure?'";
          nixos-cleanup = "sudo nix-collect-garbage -d; sudo nix-store --optimise -v";
          v = "nvim";
          vv = "sudo nvim";
          sd = "shutdown 0";
          ts = "tmux source ~/.config/tmux/custom-tmux.conf";
        };

        initContent = ''
          export PATH="$HOME/.local/bin:$PATH"
          export GTK_THEME=Adwaita:dark
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
    }
  );
}
