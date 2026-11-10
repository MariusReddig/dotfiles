{ inputs, moduleWithSystem, ... }:
{
  perSystem = {
    _module.args = {
      # Only set when evaluating with --impure from inside the repo, "" otherwise
      flakeLocation = builtins.getEnv "PWD";
    };
  };
  flake.nixosModules.nix = moduleWithSystem (
    { flakeLocation, ... }:
    { username, lib, ... }:
    {
      nix = {
        settings = {
          max-jobs = lib.mkDefault 2;
          cores = lib.mkDefault 6;

          min-free = 5 * 1024 * 1024 * 1024; # 5 GiB
          max-free = 20 * 1024 * 1024 * 1024; # 20 GiB
          keep-outputs = false;
          keep-derivations = false;

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

        # Builds run at low priority so the desktop stays responsive
        daemonCPUSchedPolicy = "batch";
        daemonIOSchedClass = "idle";

        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "nixos-config=${flakeLocation}"
        ];
        optimise.automatic = true;
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 5d";
          persistent = true; # catch up if the PC was off at the scheduled time
        };
      };

      # Hard memory cap for builds: if a build eats RAM, only the build is
      # throttled/killed, not the whole session. Percent = of physical RAM,
      # so this works on desktop and laptop alike.
      systemd.services.nix-daemon.serviceConfig = {
        MemoryHigh = "70%";
        MemoryMax = "80%";
        OOMScoreAdjust = 500; # OOM killer picks builds before the desktop
      };

      # Compressed swap in RAM, buffer against OOM during big builds
      # (desktop has no swap at all)
      zramSwap.enable = lib.mkDefault true;

      nixpkgs = {
        config = {
          allowUnfree = true;
          # Keep unstable only for what stable doesn't have / lags behind on:
          # fluxer (overlay), ryubing, archipelago. Everything else is on stable.
          packageOverrides = pkgs: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (pkgs.stdenv.hostPlatform) system;
              config = {
                allowUnfree = true;
              };
              overlays = [ inputs.fluxer.overlays.default ];
            };
          };
        };
      };
    }
  );
}
