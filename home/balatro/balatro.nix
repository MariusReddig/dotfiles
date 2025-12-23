{ config, pkgs, ... }: {
  home.packages = (with pkgs; [ love ]);
  xdg.desktopEntries = {
    balatro = {
      name = "Balatro";
      genericName = "Balatro game";
      exec = "love ${config.home.homeDirectory}/nix/home/balatro/Balatro.love";
      icon = "${config.home.homeDirectory}/nix/home/balatro/icon.png";
      terminal = false;
    };
  };
}
