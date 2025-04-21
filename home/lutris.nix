{ pkgs-unstable, ... }:
{
    home.packages = with pkgs-unstable; [
      lug-helper
      lutris
      cabextract
  ];
}
