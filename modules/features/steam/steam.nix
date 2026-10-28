{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.steam =
    {
      pkgs,
      username,
      ...
    }:
    {
      environment.systemPackages = with pkgs; [
        protonup-rs
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

      # Tray icons for Wine/Proton games (needs nixosModules.home-manager)
      home-manager.users.${username}.imports = with self.homeModules; [ wine-sni-bridge ];
    };

  flake.homeModules.wine-sni-bridge = {
    imports = [ (import "${inputs.wine-sni-bridge}/nix/module.nix") ];
    services.wine-sni-bridge.enable = true;
  };
}
