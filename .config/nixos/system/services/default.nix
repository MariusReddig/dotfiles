{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
    ./networkmanager.nix
    ./openssh.nix
    ./pipewire.nix
  ];
}
