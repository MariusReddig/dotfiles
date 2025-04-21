{ pkgs, username, pkgs-unstable, ... }:

let
  hostname = "${username}-laptop";
in
{
  # ============== System Settings ============== #
  system.stateVersion = "24.11";  # Don't remove for compatibility
  networking.hostName = hostname;

  # ============== Nix Configuration ============== #
  nix = {
    nixPath = [ "nixos-config=/home/${username}/nix" ];
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # ============== Package Management ============== #
  nixpkgs.config.allowUnfree = true;

  ## User configuration ##

  # ============== System Packages ============== #
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    neovim
    wget
    git
    git-doc
    gptfdisk
    bash

    # Nix stuff
    nix-prefetch-git

    # GUI applications
    kitty
  ] ++ (with pkgs-unstable; [
  ]);

  # ============== System Services ============== #
  mullvad.enable = true;
  sddm = {
    enable = true;
    # autoLogin.enable = true;
  };

  # ============== User Configuration ============== #
  users.users.${username} = {
    isNormalUser = true;
    description = "main user";
    extraGroups = [ "wheel" ]; # sudo user
    shell = pkgs.zsh;
  };

  # ============== Window managers ================ #
 services.displayManager.defaultSession = "hyprland";

  # ============== Programs ============== #
  steam.enable = true;
  thunar.enable = true;
  programs.zsh.enable = true;

  # ============== Imports ============== #
  imports = [
    ./hardware-configuration.nix
    ../../nixos/applications
    ../../nixos/window-managers/hyprland.nix
  ];

}
