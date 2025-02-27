# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs-unstable, ... }:
let
  user = "marius";
  hostname = "marius-desktop";
in
{

  ## System configuration ##
  bootloader.enable = true;
  #greetd-hyprland.enable = true;
  amd.enable = true;
  pipewire.enable = true;
  bluetooth.enable = true;
  localisation-de.enable = true;
  fonts.enable = true;
  keyring.enable = true;
  firefox.enable = true;
  steam.enable = true;
  programs.zsh.enable = true;

  # ## User configuration ##
  hyprland.enable = true;
  thunar.enable = true;
  main-user =
    {
      enable = true;
      userName = "${user}";
      hostName = "${hostname}";
    };

  sddm = {
    enable = true;
    autoLogin.enable = true;
  };

  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit pkgs-unstable;
  };
  programs.dconf.enable = true;
  home-manager.users = {
    "${config.main-user.userName}" = import ./../../users/${config.main-user.userName}.nix;
  };

  imports = [
    ./hardware-configuration.nix
    ./drives.nix
    ./../../system
  ];

  # System-state for compatability DONT REMOVE #
  system.stateVersion = "24.11";
}
