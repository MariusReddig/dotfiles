{ ... }:
{
  imports = [
    ./drivers
    ./file-managers
    ./localisation
    ./login-manager
    ./packages
    ./services
    ./window-managers
    ./main-user.nix
    ./keyring.nix
    ./nix.nix
    ./applications
    ./browser/firefox.nix
  ];
}
