{ config, lib, ... }:
{
  options.bootloader = {
    enable = lib.mkEnableOption "enable bootloader";
  };

  config = lib.mkIf config.bootloader.enable {
    boot.tmp.cleanOnBoot = true;
    boot.loader.systemd-boot.configurationLimit = 2;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [ "ntfs" ];
  };
}
