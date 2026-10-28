# Caelestia shell (quickshell based). Not imported by any host yet; add `caelestia`
# to a host's home-manager imports to use it.
{
  self,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.caelestia = moduleWithSystem (
    { flakeLocation, ... }:
    { config, ... }:
    {
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
          config.lib.file.mkOutOfStoreSymlink "${flakeLocation}/modules/home/caelestia/config/shell.json";
        ".config/caelestia/monitors".source =
          config.lib.file.mkOutOfStoreSymlink "${flakeLocation}/modules/home/caelestia/config/monitors";
      };
    }
  );
}
