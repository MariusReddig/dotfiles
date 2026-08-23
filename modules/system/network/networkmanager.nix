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
    networking.firewall = {
      enable = true;
      allowedUDPPortRanges = [
        {
          #KDE-Connect-range
          from = 1714;
          to = 1764;
        }
      ];
      allowedTCPPortRanges = [
        {
          #KDE-Connect-range
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
