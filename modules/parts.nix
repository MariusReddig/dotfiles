{ inputs, ... }:
{
  imports = [
    # Declares flake.homeModules (merged like flake.nixosModules) and flake.homeConfigurations
    inputs.home-manager.flakeModules.home-manager
  ];

  config = {
    systems = [ "x86_64-linux" ];
  };
}
