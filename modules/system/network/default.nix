{ self, ... }: {
  flake.nixosModules.networking =
    { pkgs, ... }:
    {
      # Certs for eg KIT-internet
      security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];

      imports = with self.nixosModules; [
        firewall
        networkmanager
      ];
    };
}
