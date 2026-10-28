{
  config,
  pkgs,
  lib,
  username,
  inputs,
  ...
}:
{
  options = {
    steam.enable = lib.mkEnableOption "enable steam module";
  };

  config = lib.mkIf (config.steam.enable || config.ubisoft.enable) {

    environment.systemPackages = with pkgs; [
      protonup-rs
      protontricks
    ];

    users.groups.gamemode.members = [ "${username}" ];

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

    # Add Home Manager configuration for wine-sni-bridge
    home-manager.users.${username} = {
      imports = [
        (import "${inputs.wine-sni-bridge}/nix/module.nix")
      ];
      services.wine-sni-bridge.enable = true;
    };
  };
}
