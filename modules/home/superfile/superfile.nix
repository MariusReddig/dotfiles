{ self, moduleWithSystem, ... }:
{
  flake.homeModules.superfile = moduleWithSystem (
    { flakeLocation, ... }:
      { pkgs, config, ... }:
      {
        programs.superfile = {
          enable = true;
          # From nixpkgs instead of the upstream flake: comes from the binary cache,
          # no local Go build and no extra nixpkgs closure.
          package = pkgs.superfile;
          metadataPackage = pkgs.exiftool;
          zoxidePackage = pkgs.zoxide;
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
