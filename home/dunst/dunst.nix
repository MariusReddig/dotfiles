{ config, ... }:
{
  services.dunst = {
    enable = true;
  };

  home.activation.linkDunstConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T ~/nix/home/dunst/dunstrc      ~/.config/dunst/dunstrc
  '';
}
