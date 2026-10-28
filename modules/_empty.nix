# Template: NixOS module. Copy it somewhere under modules/ (without the leading "_",
# files/folders starting with "_" are skipped by import-tree) and rename `name`.
#
# moduleWithSystem: the OUTER function only gets flake-parts perSystem arguments
# (self', inputs', flakeLocation, unfreePkgs, ...). The INNER function is the actual
# NixOS module and gets the normal NixOS arguments (pkgs, config, lib, username, ...).
# Only use moduleWithSystem when you need something from the outer function.
{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.name = moduleWithSystem (
    {
      self',
      inputs',
      ...
    }:
    {
      pkgs,
      config,
      lib,
      username,
      ...
    }:
    let
      modules = with self.nixosModules; [ ];
    in
    {
      imports = modules;
      environment.systemPackages = [ self'.packages.name ];
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
