{
  description = "Nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
	  ./modules/nixos/nvidia.nix
	  ./modules/nixos/hyprland.nix
	  ./modules/nixos/greeter.nix
	  ./modules/nixos/networkmanager.nix
	  ./modules/nixos/localisation.nix
	  ./main-user.nix

        ];
      };
    };
  };
}
