{ pkgs, username, host, ... }:

let
  hostname = "${username}-${host}";
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
  sddm = {
    enable = true;
    # autoLogin.enable = true;
  };
  # ============== plymouth theme =============== #
  stylix.targets.plymouth.enable = false;
  boot.plymouth = {
    theme = "thinkdar";
    themePackages = [ (pkgs.callPackage ../../nixpkgs/plymouth-themes.nix {}).thinkdar-plymouth-theme ];
  };

  # ============== User Configuration ============== #
  users.users.${username} = {
    isNormalUser = true;
    description = "main user";
    extraGroups = [ "wheel" ]; # sudo user
    shell = pkgs.zsh;
  };

  # ============== Programs ============== #
  thunar.enable = true;
  programs.zsh.enable = true;

  # ============== Imports ============== #
  imports = [
    ./hardware-configuration.nix
    ../../nixos/applications
    ../../nixos/window-managers/hyprland.nix
  ];

}
