{ self, moduleWithSystem, ... }:
{
  flake.homeModules.dunst = moduleWithSystem (
    { flakeLocation, ... }:
      { config, pkgs, ... }:
      {
        stylix.targets.dunst.enable = false;
        # services.dunst.enable = true;
        home.packages = with pkgs; [
          dunst
        ];

        home.activation.linkDunstConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
          ln -sfr -T ${flakeLocation}/modules/home/dunst/dunstrc      ~/.config/dunst/dunstrc
        '';
      }
  );
}
