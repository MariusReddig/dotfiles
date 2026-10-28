{ self, moduleWithSystem, ... }:
{
  flake.homeModules.fuzzel = moduleWithSystem (
    { flakeLocation, ... }:
      { config, ... }: {
        stylix.targets.fuzzel.enable = false;
        programs.fuzzel = { enable = true; };

        home.activation.linkFuzzelConfig =
          config.lib.dag.entryAfter [ "writeBoundary" ] ''
            ln -sfr -T ${flakeLocation}/modules/home/fuzzel/config ~/.config/fuzzel
          '';
      }
  );
}
