{ config, lib, ... }:
{
  options.amd = {
    enable = lib.mkEnableOption "enable amd drivers";
  };

  config = lib.mkIf config.amd.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];

    # for Wayland
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
