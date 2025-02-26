{ pkgs, lib, ... }: {
  imports = [
    ./nvim/nvim.nix
    ./zsh.nix
  ];
}
