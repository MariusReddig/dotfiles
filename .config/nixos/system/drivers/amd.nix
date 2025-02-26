{ config, lib, pkgs, ... }:
{
  options.amd = {
    enable = lib.mkEnableOption "enable amd drivers";
  };

  config = lib.mkIf config.amd.enable {
    environment.systemPackages = [
      pkgs.vulkan-tools
    ];

    boot.initrd.kernelModules = [ "amdgpu" ];

    # for Wayland
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
