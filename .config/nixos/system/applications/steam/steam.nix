{ config, pkgs, lib, ... }:
{
  options = {
    steam.enable = lib.mkEnableOption "enable steam module";
  };

  config = lib.mkIf config.steam.enable {
    environment.systemPackages = with pkgs; [
      mangohud
      protonup
    ];

    programs = {
      gamemode = {
        enable = true;
      };
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
