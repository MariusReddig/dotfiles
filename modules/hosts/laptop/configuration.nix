{ self, inputs, ... }:
let
  username = "marius";
  hostname = "laptop";
in
{
  flake.nixosModules.laptopConfiguration = { pkgs, lib, ... }: {
    _module.args = {
      inherit hostname username;
    };
    system.stateVersion = "24.11"; # Don't remove for compatibility
    networking.hostName = username ++ "-" ++ hostname;
    documentation.nixos.enable = false;

    environment.systemPackages = (
      with pkgs;
      [
        wget
        git
        bash
        firefox
      ]
    );
  };
}
