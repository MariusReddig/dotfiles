{ self, inputs, ... }: {
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
      ];
    in
    {
      imports = [
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
