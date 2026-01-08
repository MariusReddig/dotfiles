{ pkgs, username, host, ... }:

let hostname = "${username}-${host}";
in {
  # ============== System Settings ============== #
  system.stateVersion = "24.11"; # Don't remove for compatibility
  networking.hostName = hostname;

  # ============== Nix Configuration ============== #
  nix = {
    nixPath = [ "nixos-config=/home/${username}/nix" ];
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # ============== Package Management ============== #
  nixpkgs.config.allowUnfree = true;

  # ============== local documentation ============== #
  documentation.nixos.enable = false;

  # ============== System Packages ============== #
  environment.systemPackages = (with pkgs; [
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
  ]);

  # ============== System Services ============== #
  mullvad.enable = true;
  sddm.enable = true;

  # ============== User Configuration ============== #
  users.users.${username} = {
    isNormalUser = true;
    description = "main user";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # ============== Programs ============== #
  steam.enable = true;
  ubisoft.enable = true;
  thunar.enable = true;
  programs.zsh.enable = true;

  # ============== Imports ============== #
  imports = [
    ./hardware-configuration.nix
    ./drives.nix
    ../../nixos/applications
    ../../nixos/applications/droidcam.nix
    ../../nixos/window-managers/hyprland.nix
    ../../nixos/window-managers/gnome.nix
  ];

}
