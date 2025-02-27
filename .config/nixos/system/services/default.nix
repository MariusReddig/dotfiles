{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
    ./networkmanager.nix
    ./openssh.nix
    ./pipewire.nix
    ./firewalld.nix
    ./upower.nix
    ./garbage-collection.nix
  ];
}
