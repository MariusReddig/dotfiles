{ config, pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "start-xdg-desktop-portal" ''
      #!/bin/bash
      sleep 1
      ${pkgs.killall}/bin/killall xdg-desktop-portal-hyprland
      ${pkgs.killall}/bin/killall xdg-desktop-portal-gtk
      ${pkgs.killall}/bin/killall xdg-desktop-portal
      ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
      ${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk &
      sleep 2
      ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal &

      dbus-update-activation-environment --systemd --all
      systemctl --user import-environment QT_QPA_PLATFORMTHEME
    '')
  ];

  home.activation.linkHyprCoreFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T ~/nix/home/hyprland      ~/.config/hypr/core
  '';
}
