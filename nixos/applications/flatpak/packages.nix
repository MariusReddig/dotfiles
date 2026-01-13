{ pkgs, ... }: {
  services.flatpak.enable = true;
  services.flatpak.packages = [{
    appId = "com.stremio.Stremio";
    origin = "flathub";
  }];

  # Configure XDG portals (important for Hyprland)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
