{ ... }: {
  imports = [
    ./steam/steam.nix
    ./steam/ubisoft.nix
    ./mullvad.nix
    ./thunar.nix
    ./virt-manager.nix
    ./docker.nix
    ./screen-recorder.nix
    ./flatpak/packages.nix
  ];
}
