{
  description = "NixOs config from Marius";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
    	url = "github:nix-community/home-manager/release-24.11";
    	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      username = "marius";
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
	    username = "${username}";
          };
          modules = [
	    # Core modules needed for system
	    ./nixos/core/allow-unfree-packages.nix
	    ./nixos/core/bluetooth.nix
	    ./nixos/core/bootloader.nix
            ./nixos/core/drivers/amd.nix
	    ./nixos/core/firewalld.nix
	    ./nixos/core/garbage-collection.nix
	    ./nixos/core/keyring/gnome-keyring.nix
	    ./nixos/core/localisation/localisation-de.nix
	    ./nixos/core/login-manager/sddm.nix
	    ./nixos/core/networkmanager.nix
	    ./nixos/core/openssh.nix
	    ./nixos/core/pipewire.nix
	    ./nixos/core/upower.nix

	    # Host configuration
	    ./hosts/desktop/configuration.nix

	    # Home-manager implementation
	    home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home/home.nix;
	      home-manager.extraSpecialArgs = {
    		inherit inputs;
    		inherit pkgs-unstable;
  		username = "${username}";
		};
            }
          ];
        };
      };
    };
}
