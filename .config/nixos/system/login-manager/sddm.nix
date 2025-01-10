{ lib, config, ... }:
{
  options.sddm = {
    enable = lib.mkEnableOption "enable sddm login manager";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.sddm.autoNumlock = true;
  };
}
