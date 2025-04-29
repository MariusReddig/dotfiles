{ specialArgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${specialArgs.username} = import ../../hosts/${specialArgs.host}/home/home.nix;
    extraSpecialArgs = specialArgs;
  };
}
