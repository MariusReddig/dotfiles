{
  description = "NixOs config from Marius";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    pferd = {
      url = "github:/Garmelon/PFERD";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    awww = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wine-sni-bridge = {
      url = "github:waliori/wine-sni-bridge";
      flake = false;
    };
    fluxer = {
      url = "github:Hy4ri/fluxer-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  # https://flake.parts/module-arguments.html
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
