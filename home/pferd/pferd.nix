{ config, inputs, pkgs, ... }:
{
  home.packages = ( with inputs; [
      pferd.packages.${pkgs.system}.default
  ]);

  home.activation.linkPferdConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T ~/nix/home/pferd/pferd.cfg      ~/.config/PFERD/pferd.cfg
  '';
}
