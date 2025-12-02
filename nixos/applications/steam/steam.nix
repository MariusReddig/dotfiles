{ config, pkgs, lib, username, ... }: {
  imports = [ ./gamemode.nix ];

  options = { steam.enable = lib.mkEnableOption "enable steam module"; };

  config = lib.mkIf config.steam.enable {

    environment.systemPackages = with pkgs; [
      # if you wanna use Mangohud too see the home-manager configs.
      protonup-ng
      (writeShellScriptBin "run-game-WQHD" ''
        #!${pkgs.bash}/bin/bash
        export MANGOHUD=1  #requests mangohud
        export MANGOHUD_CONFIG=no_display
        export PULSE_SINK=game-sink

        exec gamescope \
          --adaptive-sync \
          -W 2560 \
          -H 1440 \
          --expose-wayland \
          --backend sdl \
          -- gamemoderun "$@"
      '')
      (writeShellScriptBin "run-game-WQHD-gc" ''
        #!${pkgs.bash}/bin/bash
        export MANGOHUD=1  #requests mangohud
        export MANGOHUD_CONFIG=no_display
        export PULSE_SINK=game-sink

        exec gamescope \
          --adaptive-sync \
          -W 2560 \
          -H 1440 \
          --expose-wayland \
          --force-grab-cursor \
          --backend sdl \
          -- gamemoderun "$@"
      '')
    ];

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
        remotePlay.openFirewall =
          true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall =
          true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall =
          true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
    };

    environment.sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "1";
      GDK_BACKEND = "wayland";
      NIXOS_OZONE_WL = "1";
    };
  };
}
