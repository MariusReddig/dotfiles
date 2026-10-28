{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "start-xdg-desktop-portal" ''
      #!/bin/bash
      sleep 1

      # Stop portal services first
      systemctl --user stop xdg-desktop-portal-hyprland
      systemctl --user stop xdg-desktop-portal-gtk
      systemctl --user stop xdg-desktop-portal

      # Kill any remaining processes
      ${pkgs.killall}/bin/killall xdg-desktop-portal-hyprland
      ${pkgs.killall}/bin/killall xdg-desktop-portal-gtk
      ${pkgs.killall}/bin/killall xdg-desktop-portal

      # Start the correct portals
      ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
      ${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk &
      sleep 2
      ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal &

      dbus-update-activation-environment --systemd --all
      systemctl --user import-environment QT_QPA_PLATFORMTHEME
    '')
  ];
}
