{ inputs, ... }: {
  perSystem = { system, ... }: {
    _module.args = {
      unfreePkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      flakeLocation = builtins.getEnv "PWD";
    };
  };
  flake.nixosModules.nix = { username, flakeLocation, ... }: {
    nix = {
      settings = {
        cores = 6;
        trusted-users = [
          "root"
          "user01"
        ];
        download-buffer-size = 524288000;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
        "nixos-config=${flakeLocation}"
      ];
      optimise.automatic = true;
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 5d";
      };
    };
    nixpkgs = {
      config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          unstable = import inputs.nixpkgs-unstable {
            config = {
              allowUnfree = true;
            };
          };
        };
      };
    };
  };
}
