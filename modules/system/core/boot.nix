{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.bootloader =
    {
      pkgs,
      lib,
      ...
    }:
    {
      boot = {
        loader = {
          timeout = 0; # Hides OS choice bootloaders, still possible to open by [any] keypress
          efi.canTouchEfiVariables = true;
          systemd-boot = {
            enable = true;
            configurationLimit = 5;
          };
        };

        # Enable "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "udev.log_priority=3"
          "rd.systemd.show_status=auto"
        ];
        tmp.cleanOnBoot = true;

        supportedFilesystems = [ "ntfs" ];

        #SDDM-Display-manager
        environment.systemPackages = with pkgs; [
          local.japanese-aesthetic
          kdePackages.qtmultimedia
        ];

        services = {
          displayManager = {
            sddm = {
              enable = true;
              wayland.enable = true;
              autoNumlock = true;
              theme = "japanese-aesthetic";
            };
          };
        };

      };
    };
}
