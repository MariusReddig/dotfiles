{ config, lib, pkgs, ... }:
{
    environment.systemPackages = [
      pkgs.vulkan-tools
    ];

    boot.initrd.kernelModules = [ "amdgpu" ];

    # for Wayland
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          lact
          mesa
          clinfo
        ];
      };
    };
systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = ["multi-user.target"];
    tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
  };
}
