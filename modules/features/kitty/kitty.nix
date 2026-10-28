# Kitty wrapped with nix-wrapper-modules: the config is baked into the package,
# so `nix run .#kitty` gives the same terminal on any machine.
{
  self,
  inputs,
  moduleWithSystem,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
        inherit pkgs;
        font = {
          name = "JetBrainsMono Nerd Font";
          size = 11;
        };
        settings.enable_audio_bell = false;
        # tokyo-night theme
        extraConfig = builtins.readFile ./theme.conf;
      };
    };

  flake.homeModules.kitty = moduleWithSystem (
    { self', ... }:
    { pkgs, ... }:
    {
      home.packages = [
        self'.packages.kitty
        pkgs.nerd-fonts.jetbrains-mono
      ];
    }
  );
}
