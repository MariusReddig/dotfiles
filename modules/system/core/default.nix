{ self, inputs, ... }:
{
  flake.nixosModules.core =
    {
      pkgs,
      lib,
      ...
    }:
    let
      modules = with self.nixosModules; [
        user
        bootloader
        nix
        locale
        services
        bluetooth
      ];
    in
    {
      imports = [
        # impure: build with --impure (the nixos-update alias does)
        /etc/nixos/hardware-configuration.nix
      ]
      ++ modules;

      environment.systemPackages = with pkgs; [
        vim
        unzip
        p7zip-rar
        usbutils
        lsof
        gvfs
        libnotify
        wget
        git
        bash
      ];
    };
}
