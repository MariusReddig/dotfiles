{ config, pkgs, lib, username, ... }: {
  options = { steam.enable = lib.mkEnableOption "enable steam module"; };

  config = lib.mkIf (config.steam.enable || config.ubisoft.enable) {

    environment.systemPackages = with pkgs.unstable; [
      protonup-ng
      protontricks
      # winetricks
      # wineWowPackages.staging
      # wineWowPackages.waylandFull
    ];

    users.groups.gamemode.members = [ "${username}" ];

    programs = {
      steam = {
        enable = true;
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
