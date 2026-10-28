{ self, inputs, ... }:
{
  flake.nixosModules.kde-connect = {
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
