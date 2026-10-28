{ self, inputs, moduleWithSystem, ... }:
{
  flake.homeModules.pferd = moduleWithSystem (
    { flakeLocation, ... }:
      { config, pkgs, username, ... }: {
        home.packages = (with inputs;
          [ pferd.packages.${pkgs.stdenv.hostPlatform.system}.default ]);

        home.activation.linkPferdConfig =
          config.lib.dag.entryAfter [ "writeBoundary" ] ''
            ln -sfr -T ${flakeLocation}/modules/home/pferd/pferd.cfg ~/.config/PFERD/pferd.cfg
          '';
      }
  );
}
