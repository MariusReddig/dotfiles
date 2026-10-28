{ inputs, config, ... }: {
  imports = [ inputs.caelestia.homeManagerModules.default ];
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [ ];
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = true;
      };
    };
  };
  home.file = {
    ".config/caelestia/shell.json".source =
      config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/nix/home/caelestia/config/shell.json";
    ".config/caelestia/monitors".source =
      config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/nix/home/caelestia/config/monitors";
  };
}
