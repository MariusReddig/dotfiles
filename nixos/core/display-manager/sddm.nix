{ lib, config, username, pkgs, ... }:
let
  cfg = config.sddm;
in
{
  options.sddm = {
    enable = lib.mkEnableOption "enable sddm login manager";
    autoLogin = {
      enable = lib.mkEnableOption "enable autoLogin";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.callPackage ../../../nixpkgs/sddm-themes.nix {}).sddm-sugar-dark
      pkgs.libsForQt5.qt5.qtquickcontrols2
      pkgs.libsForQt5.qt5.qtgraphicaleffects
      pkgs.libsForQt5.qt5.qtsvg
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      theme = "sugar-dark";
    };

    services.displayManager.autoLogin = lib.mkIf cfg.autoLogin.enable
      {
        enable = true;
        user = "${username}";
      };

    # enables gnome-keyring unlocking on login
    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
