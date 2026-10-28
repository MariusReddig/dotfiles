{
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.quickshell = moduleWithSystem (
    {
      self',
      inputs',
      flakeLocation,
      ...
    }:
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.packages = [ self'.packages.quickshell ];

      home.activation.linkName = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfr -T ${flakeLocation}/modules/home/quickshell/config ~/.config/quickshell
      '';
    }
  );
}
