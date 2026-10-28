{
  self,
  ...
}:
{
  flake.nixosModules.docker =
    {
      username,
      ...
    }:
    {
      virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
      users.users.${username}.extraGroups = [ "docker" ];
    };
}
