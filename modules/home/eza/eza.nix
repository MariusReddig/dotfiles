{ self, ... }:
{
  flake.homeModules.eza =
    {...}:
    {
      programs.eza = {
        enable = true;
        enableZshIntegration = true;
        colors = "auto";
        git = true;
        icons = "auto";
      };
    };
}
