# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, nixpkgs, ... }:

{
  imports = [
		./hardware-configuration.nix
		../../main-user.nix
		inputs.home-manager.nixosModules.default
  ];

  main-user.enable = true;
  main-user.userName = "marius";
  main-user.hostName = "marius-desktop";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    python312Packages.pip
    wget
    pavucontrol
    usbutils
    firewalld
    openssh
    nwg-displays
    easyeffects
    blueman
    networkmanagerapplet
  ];

	home-manager.extraSpecialArgs = { inherit inputs; };
	home-manager.users = { "marius" = import ./marius; };
	programs.dconf.enable = true;
	
  system.stateVersion = "24.11";
}
