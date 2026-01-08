{ config, pkgs, lib, username, ... }: {
  options = { steam.enable = lib.mkEnableOption "enable steam module"; };

  config = lib.mkIf (config.steam.enable || config.ubisoft.enable) {

    environment.systemPackages = with pkgs; [ protonup-ng ];

    users.groups.gamemode.members = [ "${username}" ];

    programs = {
      gamemode = { enable = true; };
      gamescope = {
        enable = true;
        capSysNice = true;
        package = pkgs.unstable.gamescope;
      };

      steam = {
        enable = true;
        gamescopeSession.enable = true;
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
