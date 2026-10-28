{ self, ... }:
{
  flake.homeModules.zoxide =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
      zoxide
      fzf
      ];
      programs.zsh.enable = true;
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [
          "--cmd cd"
        ];
      };
    };
}
