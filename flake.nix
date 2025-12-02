{
  description = "NixOs config from Marius";

  inputs = {
    # Stable channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unstable channels
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    mic92-nur = {
      url = "github:mic92/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; # Keep in sync
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

      unstableOverlay = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ inputs.nur.overlays.default ];
        };
      };

      localOverlay = final: prev: {
        local = (import ./nixpkgs/default.nix) { pkgs = prev; };
      };

      # Module system
      mkModule = path: { imports = [ path ]; };
      coreModule = name: mkModule ./nixos/core/${name}.nix;
    in {
      nixosConfigurations = {
        desktop = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system username;
            host = "desktop";
          };
          modules = [
            # Core system modules
            { nixpkgs.overlays = [ unstableOverlay localOverlay ]; }
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
            (coreModule "nix-ld")
            (coreModule "docker")
            (coreModule "battery-monitor")

            # Host configuration
            ./hosts/desktop/configuration.nix

            # Home-manager implementation
            inputs.home-manager.nixosModules.home-manager
            (coreModule "home-manager")

            # Stylix
            inputs.stylix.nixosModules.stylix
            ./stylix/stylix.nix
          ];
        };
        laptop = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system username;
            host = "laptop";
          };
          modules = [
            # Core system modules
            { nixpkgs.overlays = [ unstableOverlay ]; }
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
            (coreModule "docker")
            (coreModule "battery-monitor")

            # Host configuration
            ./hosts/laptop/configuration.nix

            # Home-manager implementation
            inputs.home-manager.nixosModules.home-manager
            (coreModule "home-manager")

            # Stylix
            inputs.stylix.nixosModules.stylix
            ./stylix/stylix.nix
          ];
        };

      };
    };
}
