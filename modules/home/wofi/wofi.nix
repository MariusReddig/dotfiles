# Not used by any host right now (fuzzel replaced it).
{ self, moduleWithSystem, ... }:
{
  flake.homeModules.wofi = moduleWithSystem (
    { flakeLocation, ... }:
      { config, ... }:
      {
        stylix.targets.wofi.enable = false;
        programs.wofi = {
        enable = true;
        };

        home.activation.linkWofiConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
          ln -sfr -T ${flakeLocation}/modules/home/wofi ~/.config/wofi
        '';
      }
  );
}
