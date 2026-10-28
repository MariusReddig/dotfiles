{ self, inputs, ... }:
{
  flake.nixosModules.flatpak =
    { pkgs, lib, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      services.flatpak = {
        enable = true;
        packages = [
          {
            appId = "com.stremio.Stremio";
            origin = "flathub";
          }
          {
            appId = "io.github.Soundux";
            origin = "flathub";
          }
        ];
      };

      # Configure XDG portals (important for Hyprland)
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
      };
    };
}
