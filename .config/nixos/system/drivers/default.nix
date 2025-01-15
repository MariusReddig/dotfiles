{ pkgs, lib, ... }: {
  imports = [
    ./nvidia.nix
    ./amd.nix
  ];
}
