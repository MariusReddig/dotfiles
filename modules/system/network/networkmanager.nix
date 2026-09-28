{ self, inputs, ... }: {
  flake.nixosModules.netwworkmanager = { username, pkgs, ... }: {
    environment.systemPackages = (
      with pkgs;
      [
        openvpn
        strongswan
      ]
    );
    networking.networkmanager = {
      enable = true;
      plugins = (
        with pkgs;
        [
          networkmanager-openvpn
          networkmanager-strongswan
        ]
      );
    };
  };
}
