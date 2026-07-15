{ config, pkgs, ... }:
let
  balatro-modded = pkgs.stdenv.mkDerivation {
    name = "balatro-modded";
    src = "${config.home.homeDirectory}/nix/home/balatro";
    buildCommand = ''
      mkdir -p $out/bin
      cat > $out/bin/balatro-modded << EOF
      #!${pkgs.stdenv.shell}
      cd ${config.home.homeDirectory}/nix/home/balatro
      export LD_PRELOAD=${config.home.homeDirectory}/nix/home/balatro/liblovely.so
      exec ${pkgs.love}/bin/love Balatro.love
      EOF
      chmod +x $out/bin/balatro-modded
    '';
  };

  # Vanilla Balatro (no mods)
  balatro-vanilla = pkgs.stdenv.mkDerivation {
    name = "balatro-vanilla";
    src = "${config.home.homeDirectory}/nix/home/balatro";
    buildCommand = ''
      mkdir -p $out/bin
      cat > $out/bin/balatro << EOF
      #!${pkgs.stdenv.shell}
      cd ${config.home.homeDirectory}/nix/home/balatro
      exec ${pkgs.love}/bin/love Balatro.love
      EOF
      chmod +x $out/bin/balatro
    '';
  };
in {
  home.packages = with pkgs; [ love balatro-modded balatro-vanilla ];

  xdg.desktopEntries = {
    balatro = {
      name = "Balatro";
      genericName = "A Poker inspired Rougelike";
      exec = "balatro";
      icon = "${config.home.homeDirectory}/nix/home/balatro/icon.png";
      terminal = false;
      categories = [ "Game" ];
    };

    "balatro-modded" = {
      name = "Balatro (Modded)";
      genericName = "Balatro game with mods";
      exec = "balatro-modded";
      icon = "${config.home.homeDirectory}/nix/home/balatro/icon.png";
      terminal = false;
      categories = [ "Game" ];
    };
  };

  home.activation.linkBalatroFiles =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfr -T ${config.home.homeDirectory}/nix/home/balatro/config ${config.home.homeDirectory}/.local/share/love
      # ln -sfr -T ${config.home.homeDirectory}/nix/home/balatro/config/Mods/Balatro ${config.home.homeDirectory}/.local/share/love/Balatro
      # ln -sfr -T ${config.home.homeDirectory}/nix/home/balatro/Balatro.love ${config.home.homeDirectory}/nix/home/balatro/config/Mods/Balatro/Balatro.love
    '';
}
