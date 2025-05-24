{ pkgs, config, username, ... }:
{
  home.packages = (with pkgs; [
    xorg.libX11
  ]);

  stylix.targets.mangohud.enable = false;
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    package = pkgs.mangohud;
    };

  home.activation.linkMangoConf = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T /home/${username}/nix/home/mangohud/config ~/.config/MangoHud
  '';
}
