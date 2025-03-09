{ config, pkgs, lib, ... }:
{
  options = {
    steam.enable = lib.mkEnableOption "enable steam module";
  };

  config = lib.mkIf config.steam.enable {
    environment.systemPackages = with pkgs; [
      mangohud
      protonup
      (writeShellScriptBin "run-game" ''
        #!/bin/bash
        export MANGOHUD=1  #requests mangohud
        export MANGOHUD_CONFIG=no_display
        export LD_PRELOAD="" #clears library preloads
        # export VKD3D_CONFIG=disable_uav_compression

        exec gamemoderun gamescope \
          --adaptive-sync \
          --steam \
          -W 1920 \
          -H 1080 \
          --expose-wayland \
          -- "$@"
      '')
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
