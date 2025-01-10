# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
  user = "marius";
  hostname = "marius-desktop";
in
{

  ## System configuration ##
  bootloader.enable = true;
  bluetooth.enable = true;
  #sddm.enable = true;
  greetd-hyprland.enable = true;
  fonts.enable = true;
  localisation-de.enable = true;
  pipewire.enable = true;
  hyprland.enable = true;

  # ## User configuration ##
  main-user.enable = true;
  main-user.userName = "${user}";
  main-user.hostName = "${hostname}";
  programs.zsh.enable = true;


  ## configuration packages ##
  #NOTE needs to be modularized for better flexibility!
  environment.systemPackages = with pkgs; [
    pavucontrol
    firewalld
    nwg-displays
    easyeffects
    blueman
    networkmanagerapplet
  ];

  home-manager.extraSpecialArgs = { inherit inputs; };
  programs.dconf.enable = true;
  home-manager.users = {
    "${config.main-user.userName}" = import ./../../users/${config.main-user.userName};
  };

  imports = [
    ./hardware-configuration.nix
    ./../../system
  ];

  # System-state for compatability DONT REMOVE #
  system.stateVersion = "24.11";
}
