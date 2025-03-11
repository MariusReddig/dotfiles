{ lib, config, username, ... }:
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
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      theme = "custom-theme-1";
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
