{
  description = "NixOs config from Marius";

  inputs = {
    # Stable channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-24.11";

    # Unstable channels
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    mic92-nur = {
      url = "github:mic92/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs-unstable";  # Keep in sync
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, nur, mic92-nur, ... }@inputs:
    let
      username = "marius";
      system = "x86_64-linux";

      # Package sets
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nur.overlays.default ];
      };

      # Module system
      mkModule = path: { imports = [ path ]; };
      coreModule = name: mkModule ./nixos/core/${name}.nix;
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system username pkgs-unstable; };
          modules = [
            # Core system modules
            (coreModule "bluetooth")
            (coreModule "bootloader")
            (coreModule "drivers/amd")
            (coreModule "firewalld")
            (coreModule "garbage-collection")
            (coreModule "keyring/gnome-keyring")
            (coreModule "localisation/localisation-de")
            (coreModule "display-manager/sddm")
            (coreModule "networkmanager")
            (coreModule "openssh")
            (coreModule "pipewire")
            (coreModule "upower")

            # Host configuration
            ./hosts/desktop/configuration.nix

            # Home-manager implementation
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./hosts/desktop/home/home.nix;
                extraSpecialArgs = { inherit inputs system username pkgs-unstable; };
              };
            }

            # Stylix
            stylix.nixosModules.stylix
            ./stylix/stylix.nix
          ];
        };
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs system username pkgs-unstable; };
          modules = [
            # Core system modules
            (coreModule "bluetooth")
            (coreModule "bootloader")
            (coreModule "drivers/amd")
            (coreModule "firewalld")
            (coreModule "garbage-collection")
            (coreModule "keyring/gnome-keyring")
            (coreModule "localisation/localisation-de")
            (coreModule "display-manager/sddm")
            (coreModule "networkmanager")
            (coreModule "openssh")
            (coreModule "pipewire")
            (coreModule "upower")

            # Host configuration
            ./hosts/laptop/configuration.nix

            # Home-manager implementation
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./hosts/laptop/home/home.nix;
                extraSpecialArgs = { inherit inputs system username pkgs-unstable; };
              };
            }

            # Stylix
            stylix.nixosModules.stylix
            ./stylix/stylix.nix
          ];
        };

      };
    };
}
