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
    pferd = {
      url = "github:/Garmelon/PFERD";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww.url = "github:LGFae/swww";
  };

  outputs = { self, ... }@inputs:
    let
      username = "marius";
      system = "x86_64-linux";

      # Package sets
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [ inputs.nur.overlays.default ];
      };

      # Module system
      mkModule = path: { imports = [ path ]; };
      coreModule = name: mkModule ./nixos/core/${name}.nix;
    in
    {
      nixosConfigurations = {
        desktop = inputs.nixpkgs.lib.nixosSystem {
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
            (coreModule "certificates")

            # Host configuration
            ./hosts/desktop/configuration.nix

            # Home-manager implementation
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./hosts/desktop/home/home.nix;
                extraSpecialArgs = { inherit inputs system username pkgs-unstable; };
              };
            }

            # Stylix
            inputs.stylix.nixosModules.stylix
            ./stylix/stylix.nix
          ];
        };
        laptop = inputs.nixpkgs.lib.nixosSystem {
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
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./hosts/laptop/home/home.nix;
                extraSpecialArgs = { inherit inputs system username pkgs-unstable; };
              };
            }

            # Stylix
            inputs.stylix.nixosModules.stylix
            ./stylix/stylix.nix
          ];
        };

      };
    };
}
