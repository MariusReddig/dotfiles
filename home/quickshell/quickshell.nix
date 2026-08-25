{
  config,
  inputs,
  pkgs,
  username,
  ...
}:
{
  home.packages = (with pkgs; [ quickshell ]);

  home.activation.linkPferdConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T /home/${username}/nix/home/quickshell/config ~/.config/quickshell/
  '';
}
