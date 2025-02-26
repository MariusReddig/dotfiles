{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;[
    cpupower-gui
  ];
  services.upower.enable = true;
  services.cpupower-gui.enable = true;
}
