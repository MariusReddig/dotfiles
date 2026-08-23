{ self, inputs, ... }: {
  flake.nixModules.amd =
    {
      config,
      lib,
      pkgs,
      ...
    }:
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
            mesa
            clinfo
          ];
          amdgpu = {
            initrd.enable = true;
            opencl.enable = true;
          };
        };
      };
      systemd = {
        tmpfiles.rules = [
          "L+    /opt/rocm   -    -    -     -    ${pkgs.rocmPackages.clr}"
        ];
      };
    };
}
