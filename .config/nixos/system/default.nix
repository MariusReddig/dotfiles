{ ... }:
{
  imports = [
    ./drivers
    ./localisation
    ./login-manager
    ./packages
    ./services
    ./window-managers
    ./main-user.nix
    ./nix.nix
  ];
}
