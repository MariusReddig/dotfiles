{ config, lib, ... }:
{
    boot.tmp.cleanOnBoot = true;
    boot.loader.systemd-boot.configurationLimit = 2;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [ "ntfs" ];
}
