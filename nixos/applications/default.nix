{ ... }: {
  imports = [
    ./steam/steam.nix
    ./steam/ubisoft.nix
    ./mullvad.nix
    ./thunar.nix
    ./virt-manager.nix
    ./docker.nix
  ];
}
