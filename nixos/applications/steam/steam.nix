{ config, pkgs, lib, ... }:
{
  imports = [
    ./gamemode.nix
  ];

  options = {
    steam.enable = lib.mkEnableOption "enable steam module";
  };

  config = lib.mkIf config.steam.enable {

    environment.systemPackages = with pkgs; [
      mangohud
      protonup
      (writeShellScriptBin "run-game-HD" ''
        #!/bin/bash
        export MANGOHUD=1  #requests mangohud
        export MANGOHUD_CONFIG=no_display
        export LD_PRELOAD="" #clears library preloads
        export PULSE_SINK=game-sink gamescope
        # export VKD3D_CONFIG=disable_uav_compression

        exec gamemoderun gamescope \
          --adaptive-sync \
          --steam \
          -W 1920 \
          -H 1080 \
          --expose-wayland \
          -- "$@"
      '')
        (writeShellScriptBin "run-game-WQHD" ''
        #!/bin/bash
        export MANGOHUD=1  #requests mangohud
        export MANGOHUD_CONFIG=no_display
        export LD_PRELOAD="" #clears library preloads
        export PULSE_SINK=game-sink gamescope
        # export VKD3D_CONFIG=disable_uav_compression

        exec gamemoderun gamescope \
          --adaptive-sync \
          --steam \
          -W 2560 \
          -H 1440 \
          --expose-wayland \
          -- "$@"
      '')

            (writeShellScriptBin "run-game-4k" ''
        #!/bin/bash
        export MANGOHUD=1  #requests mangohud
        export MANGOHUD_CONFIG=no_display
        export LD_PRELOAD="" #clears library preloads
        exprot PULSE_SINK=GameSink gamescope #routes Games to specific wireplumber sink
        # export VKD3D_CONFIG=disable_uav_compression

        exec gamemoderun gamescope \
          --adaptive-sync \
          --steam \
          -W 3840 \
          -H 1920 \
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

    environment.sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "1";
      GDK_BACKEND = "wayland";
      NIXOS_OZONE_WL = "1";
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
