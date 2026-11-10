# Laptop only: switches power-profiles-daemon between power-saver (on
# battery) and balanced (on AC) automatically via udev, since Hyprland
# has no session-level logic for this (unlike GNOME/KDE).
{ self, inputs, ... }:
{
  flake.nixosModules.power-profile-switch =
    { pkgs, ... }:
    let
      onBattery = pkgs.writeShellScript "power-profile-on-battery.sh" ''
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
      '';
      onAC = pkgs.writeShellScript "power-profile-on-ac.sh" ''
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
      '';
    in
    {
      services.udev.extraRules = ''
        SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="0", RUN+="${onBattery}"
        SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ATTR{online}=="1", RUN+="${onAC}"
      '';
    };
}
