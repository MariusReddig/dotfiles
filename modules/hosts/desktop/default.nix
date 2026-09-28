{ self, inputs, ... }:
let
  username = "marius";
  hostname = "desktop";
in
{
  flake.nixosModules.desktopconfiguration = { pkgs, lib, ... }: {
    _module.args = {
      inherit hostname username;
    };
    system.stateversion = "24.11"; # don't remove for compatibility
    networking.hostname = hostname;

    documentation.nixos.enable = false;

    imports = [
    ];

    home-manager.users.${username} =
      { ... }@homeConfig:
      {
        imports = [
        ];
      };

    environment.systempackages = (
      with pkgs;
      [
        wget
        git
        bash
      ]
    );
  };
}
