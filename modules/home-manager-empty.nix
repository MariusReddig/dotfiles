{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.name = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    let
      modules = with self.homeModules; [ ];
    in
    {
      imports = modules;
      home.packages = [ self'.packages.hello ];
      programs.hello = {
        enable = true;
      };
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
      packages.hello = pkgs.hello;
    };
}
