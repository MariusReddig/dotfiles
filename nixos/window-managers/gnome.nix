{ ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };
  services.gnome.core-apps.enable = false;
}
