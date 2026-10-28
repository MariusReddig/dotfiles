# Home Manager as a NixOS module. Hosts add their user modules with
#   home-manager.users.${username}.imports = with self.homeModules; [ ... ];
# `username` and `hostname` are passed on to every Home Manager module.
{ self, inputs, ... }:
{
  flake.nixosModules.home-manager =
    { username, hostname, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit username hostname; };
        users.${username}.imports = with self.homeModules; [ base ];
      };
    };
}
