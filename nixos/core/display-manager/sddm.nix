{ lib, config, username, pkgs, ... }:
let cfg = config.sddm;
in {
  options.sddm = { enable = lib.mkEnableOption "enable sddm login manager"; };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      local.japanese-aesthetic
      kdePackages.qtmultimedia
    ];

    services = {
      displayManager = {
        defaultSession = "hyprland";
        sddm = {
          enable = true;
          wayland.enable = true;
          autoNumlock = true;
          theme = "sddm-astronaut-theme";
        };
      };
    };

    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}
