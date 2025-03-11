{ lib, config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
      libsecret
      gcr
      gnome-keyring
      seahorse
    ];

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    programs.seahorse.enable = true;
}
