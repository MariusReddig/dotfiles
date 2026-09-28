{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.steam = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    let
      modules = with self.nixosModules; [ ];
    in
    {
      imports = modules;
      environment.systemPackages = with pkgs; [
        protonup-ng
        protontricks
      ];

      hardware.steam-hardware.enable = true;
      programs = {
        steam = {
          enable = true;
          package = self'.packages.steam;
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
    }
  );
  perSystem =
    {
      config,
      pkgs,
      lib,
      username,
      ...
    }:
    {
    };
}
