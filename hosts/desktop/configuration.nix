# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, pkgs-unstable, username, ... }:
let
  hostname = "${username}-desktop";
in
{

  ## System configuration ##
  programs.zsh.enable = true;
  steam.enable = true;
  thunar.enable = true;
  mullvad.enable = true;

  # ## User configuration ##
  users.users.${username} = {
    isNormalUser = true;
    description = "main user";
    extraGroups = [ "wheel" "networkmanager" "gamemode" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    tmux
    kitty
    git
    git-doc
  ];

  networking.hostName = "${hostname}";
  sddm = {
    enable = true;
    autoLogin.enable = true;
  };

  imports = [
    ./hardware-configuration.nix
    ./drives.nix
    ../../nixos/applications
    ../../nixos/window-managers/hyprland.nix
  ];

  # System-state for compatability DONT REMOVE #
  system.stateVersion = "24.11";
}
