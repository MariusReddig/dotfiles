{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.docker = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      user,
      ...
    }:
    let
      modules = with self.nixosModules; [ ];
    in
    {
      imports = modules;
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
      users.user.${user}.extraGroups = [ "docker" ];

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
    };
}
