{ inputs, moduleWithSystem, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args = {
        unfreePkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        # Only set when evaluating with --impure from inside the repo, "" otherwise
        flakeLocation = builtins.getEnv "PWD";
      };
    };
  flake.nixosModules.nix = moduleWithSystem (
    { flakeLocation, ... }:
    { username, ... }:
    {
      nix = {
        settings = {
          cores = 6;
          trusted-users = [
            "root"
            username
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
              inherit (pkgs.stdenv.hostPlatform) system;
              config = {
                allowUnfree = true;
              };
            };
          };
        };
      };
    }
  );
}
