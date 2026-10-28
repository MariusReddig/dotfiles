# Flatpaks via nix-flatpak. The XDG portals are set up in features/hyprland.
# sm64ap-launcher is installed from a local bundle: put sm64ap-launcher.flatpak next to this file
# (it is not tracked in git).
{
  self,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.flatpak = moduleWithSystem (
    { flakeLocation, ... }:
    { pkgs, lib, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = [
          {
            appId = "com.usebottles.bottles";
            origin = "flathub";
          }
          {
            appId = "io.github.n00byking.sm64ap-launcher";
            bundle = "file://${flakeLocation}/modules/features/flatpak/sm64ap-launcher.flatpak";
          }
        ];
      };
    }
  );
}
