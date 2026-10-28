{ self, moduleWithSystem, ... }:
{
  flake.homeModules.balatro = moduleWithSystem (
    { flakeLocation, ... }:
      { config, pkgs, ... }:
      let
        balatro-modded = pkgs.stdenv.mkDerivation {
          name = "balatro-modded";
          src = "${flakeLocation}/modules/home/balatro";
          buildCommand = ''
            mkdir -p $out/bin
            cat > $out/bin/balatro-modded << EOF
            #!${pkgs.stdenv.shell}
            cd ${flakeLocation}/modules/home/balatro
            export LD_PRELOAD=${flakeLocation}/modules/home/balatro/liblovely.so
            exec ${pkgs.love}/bin/love Balatro.love
            EOF
            chmod +x $out/bin/balatro-modded
          '';
        };

        # Vanilla Balatro (no mods)
        balatro-vanilla = pkgs.stdenv.mkDerivation {
          name = "balatro-vanilla";
          src = "${flakeLocation}/modules/home/balatro";
          buildCommand = ''
            mkdir -p $out/bin
            cat > $out/bin/balatro << EOF
            #!${pkgs.stdenv.shell}
            cd ${flakeLocation}/modules/home/balatro
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
            icon = "${flakeLocation}/modules/home/balatro/icon.png";
            terminal = false;
            categories = [ "Game" ];
          };

          "balatro-modded" = {
            name = "Balatro (Modded)";
            genericName = "Balatro game with mods";
            exec = "balatro-modded";
            icon = "${flakeLocation}/modules/home/balatro/icon.png";
            terminal = false;
            categories = [ "Game" ];
          };
        };

        home.activation.linkBalatroFiles =
          config.lib.dag.entryAfter [ "writeBoundary" ] ''
            ln -sfr -T ${flakeLocation}/modules/home/balatro/config ${config.home.homeDirectory}/.local/share/love
            # ln -sfr -T ${flakeLocation}/modules/home/balatro/config/Mods/Balatro ${config.home.homeDirectory}/.local/share/love/Balatro
            # ln -sfr -T ${flakeLocation}/modules/home/balatro/Balatro.love ${flakeLocation}/modules/home/balatro/config/Mods/Balatro/Balatro.love
          '';
      }
  );
}
