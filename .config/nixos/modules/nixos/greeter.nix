{ lib, config, pkgs, ... }:
{
  # tweaked for Hyprland
  # ...
  # launches swaylock with exec-once in home/hyprland/hyprland.conf
  # ...
  # single user and single window manager
  # my goal here is auto-login with authentication
  # so I can declare my user and environment (Hyprland) in this config
  # my goal is NOT to allow user selection or environment selection at the the login screen
  # (which a login manager provides beyond just the authentication check)
  # so I don't need a login manager
  # I just launch Hyprland as iancleary automatically, which starts swaylock (to authenticate)
  # I thought I needed a greeter, but I really don't
  # ...
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "marius";
      };
    default_session = initial_session;
    };
  };

  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
}
