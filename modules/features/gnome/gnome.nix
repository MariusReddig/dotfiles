{ self, ... }:
{
  flake.nixosModules.gnome = {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = false;
      gnome.core-apps.enable = false;
    };
  };
}
