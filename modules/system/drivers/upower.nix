{ self, inputs, ... }: {
  flake.nixosModules.upower =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        upower
        # cpupower-gui
      ];
      services = {
        upower.enable = true;
        # cpupower-gui.enable = true;
        power-profiles-daemon.enable = true;
      };
    };
}
