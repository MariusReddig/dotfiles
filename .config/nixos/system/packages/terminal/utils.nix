{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.bash
    pkgs.wget
    pkgs.git
    pkgs.usbutils
    pkgs.fastfetch
  ];
}
