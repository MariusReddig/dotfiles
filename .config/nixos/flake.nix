{
  description = "NixOs config from Marius";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		hyprland.url = "github:hyprwm/Hyprland";
		hyprland.inputs.nixpkgs.follows = "nixpkgs";
		swww.url = "github:LGFae/swww";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      workstation = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
					./hosts/pc
					./modules
				];
      };
    };
  };
}
