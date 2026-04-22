{ pkgs, ... }: {
  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr pkgs.hplip ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
