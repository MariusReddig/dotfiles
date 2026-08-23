{ self, inputs, ... }:
let
  username = "marius";
  hostname = "desktop";
in
{
  flake.nixosModules.desktopConfiguration = { pkgs, lib, ... }: {
    _module.args = {
      inherit hostname username;
    };
    system.stateVersion = "24.11"; # Don't remove for compatibility
    networking.hostName = hostname;

    documentation.nixos.enable = false;

    imports = [
    ];

    environment.systemPackages = (
      with pkgs;
      [
        wget
        git
        bash
      ]
    );
  };
}
