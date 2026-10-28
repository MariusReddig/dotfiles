{ self, inputs, moduleWithSystem, ... }:
{
  flake.homeModules.superfile = moduleWithSystem (
    { flakeLocation, ... }:
      { pkgs, config, ... }:
      let
        superfile =
          inputs.superfile.packages.${pkgs.stdenv.hostPlatform.system}.default;
        superfileWithoutChecks = superfile.overrideAttrs (old: {
          doCheck = false;
          doInstallCheck = false;
        });
      in {
        programs.superfile = {
          enable = true;
          package = superfileWithoutChecks;
          metadataPackage = pkgs.unstable.exiftool;
          zoxidePackage = pkgs.unstable.zoxide;
          # settings = builtins.fromTOML (builtins.readFile ./config.toml);
        };

        home.activation.linkSuperfileConfig =
          config.lib.dag.entryAfter [ "writeBoundary" ] ''
            ln -sfr -T ${flakeLocation}/modules/home/superfile/config.toml ~/.config/superfile/config.toml
            ln -sfr -T ${flakeLocation}/modules/home/superfile/pinned.json ~/.local/share/superfile/pinned.json
          '';
      }
  );
}
