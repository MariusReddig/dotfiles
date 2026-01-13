{ pkgs, lib, ... }: {
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = (with pkgs; [ xdg-desktop-portal-gtk ]);

  environment.sessionVariables = {
    PATH = "$PATH:${pkgs.flatpak}/bin";
    XDG_DATA_DIRS = lib.mkDefault
      "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  };
}
