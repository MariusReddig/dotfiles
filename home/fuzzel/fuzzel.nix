{ config, ... }:
{
  programs.fuzzel = {
    enable = true;
  };

  home.activation.linkFuzzelConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T ~/nix/home/fuzzel/fuzzel.ini ~/.config/fuzzel.ini
  '';
}
