{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.zsh = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      flakeLocation,
      ...
    }:
    let
      modules = with self.nixosModules; [ ];
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

        shellAliases = {
          ll = "ls -l";
          la = "ls -la";
          nixos-update =
            if flakeLocation != "" then
              "( cd ${flakeLocation} && sudo nixos-rebuild switch --impire --flake .)"
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
          ts = "tmux source ~/.config/tmux/tmux.conf";
          spf = "supferfile";
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
    }
  );
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
    };
}
