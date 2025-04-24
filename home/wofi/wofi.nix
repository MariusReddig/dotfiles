{ config, ... }:
{
  stylix.targets.wofi.enable = false;
  programs.wofi = {
  enable = true;
  };

  home.activation.linkWofiConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T ~/nix/home/wofi ~/.config/wofi
  '';
}
