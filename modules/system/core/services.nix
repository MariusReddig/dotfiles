{ self, inputs, ... }: {
  flake.nixosModules.services =
    {
      pkgs,
      lib,
      ...
    }:
    {
      services = {
        openssh.enable = true;
        lact.enable = true;
        printing = {
          enable = true;
          drivers = [
            pkgs.epson-escpr
            pkgs.hplip
          ];
        };
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
      };
    };
}
