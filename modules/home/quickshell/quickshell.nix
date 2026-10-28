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
      home.packages = [ pkgs.quickshell ];

      home.activation.linkQuickshellConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfr -T ${flakeLocation}/modules/home/quickshell/config ~/.config/quickshell
      '';
    }
  );
}
