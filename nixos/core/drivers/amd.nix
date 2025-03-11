{ config, lib, pkgs, ... }:
{
    environment.systemPackages = [
      pkgs.vulkan-tools
    ];

    boot.initrd.kernelModules = [ "amdgpu" ];

    # for Wayland
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # rocmPackages.clr.icd
        clinfo
      ];
    };
}
