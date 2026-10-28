{
  self,
  ...
}:
{
  flake.nixosModules.steam =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        protonup-ng
        protontricks
      ];

      hardware.steam-hardware.enable = true;
      programs = {
        steam = {
          enable = true;
          extest.enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };
      };

      environment.sessionVariables = {
        STEAM_FORCE_DESKTOPUI_SCALING = "1";
        GDK_BACKEND = "wayland";
        NIXOS_OZONE_WL = "1";
      };
    };
}
