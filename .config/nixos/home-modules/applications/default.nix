{ pkgs, lib, ... }: {
  imports = [
    ./nvim.nix
    ./zsh.nix
    ./mullvad-vpn.nix
  ];
}
