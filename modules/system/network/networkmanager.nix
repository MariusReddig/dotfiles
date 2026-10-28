{ self, inputs, ... }: {
  flake.nixosModules.networkmanager = { pkgs, ... }: {
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
