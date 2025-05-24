{ ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };
  services.gnome.core-utilities.enable = false;
}
