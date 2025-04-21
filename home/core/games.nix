{ pkgs, pkgs-unstable, ... }:
{
  imports = [
    ../mangohud/mangohud.nix
  ];

  home.packages =
    (with pkgs; [
      # Minecraft
      prismlauncher
    ])
    ++
    (with pkgs-unstable; [
      # Switch emulation
      ryujinx

      #Lutris
      lug-helper
      lutris
      cabextract
    ]);

}
