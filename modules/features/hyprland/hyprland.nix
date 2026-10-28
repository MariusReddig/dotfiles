# Hyprland: compositor on the system side, config links + helper scripts on the user side.
# chwp.nix, toggles.nix, hyprlock.nix and hypridle.nix in this folder add to the same
# homeModules.hyprland; the per-host lua config lives in modules/hosts/<host>/hyprland.
{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;
      };

      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
        systemPackages = with pkgs; [
          hyprlock
          hypridle
          hyprpolkitagent
          hyprland-protocols
          hyprshutdown
          hyprpicker
          hyprpwcenter
          waybar
        ];
      };
    };

  flake.homeModules.hyprland = moduleWithSystem (
    { flakeLocation, ... }:
    {
      config,
      pkgs,
      hostname,
      ...
    }:
    {
      home.activation.linkHyprConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ~/.config/hypr
        ln -sfrT ${flakeLocation}/modules/features/hyprland/core-config  ~/.config/hypr/core-config
        ln -sfrT ${flakeLocation}/modules/features/hyprland/hyprland.lua ~/.config/hypr/hyprland.lua
        ln -sfrT ${flakeLocation}/modules/hosts/${hostname}/hyprland     ~/.config/hypr/host-config
      '';

      home.file.".config/hypr/xdph.conf".text = ''
        screencopy {
            max_fps = 60
            cursor_mode = 2
        }
      '';

      home.packages = [
        (pkgs.writeShellScriptBin "start-xdg-desktop-portal" ''
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
    }
  );
}
