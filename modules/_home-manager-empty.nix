# Template: Home Manager module. Copy it somewhere under modules/ (without the leading "_",
# files/folders starting with "_" are skipped by import-tree) and rename `name`.
# Hosts pick it up with `home-manager.users.${username}.imports = with self.homeModules; [ name ];`
#
# moduleWithSystem: OUTER function = perSystem args (self', inputs', flakeLocation, ...),
# INNER function = the Home Manager module (pkgs, config, lib, username, hostname, ...).
{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.name = moduleWithSystem (
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
    let
      modules = with self.homeModules; [ ];
    in
    {
      imports = modules;
      home.packages = [ self'.packages.name ];

      # Live-editable config file next to this module:
      # home.activation.linkName = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      #   ln -sfr -T ${flakeLocation}/modules/home/name/config ~/.config/name
      # '';
    }
  );

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      # packages.name = pkgs.hello;
    };
}
