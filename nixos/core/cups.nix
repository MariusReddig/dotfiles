{ pkgs, ... }:
{
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
