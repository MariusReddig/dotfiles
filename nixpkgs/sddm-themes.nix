{ pkgs }:
{
  sddm-sugar-dark = pkgs.stdenv.mkDerivation rec {
    name = "sddm-sugar-dark-theme";
    src = pkgs.fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
      sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
    };
    installPhase = ''
          mkdir -p $out/share/sddm/themes
          cp -aR $src $out/share/sddm/themes/sugar-dark
      '';
    nativeBuildInputs = [ pkgs.libsForQt5.qt5.wrapQtAppsHook ];
    buildInputs = [
        pkgs.libsForQt5.qt5.qtquickcontrols2
        pkgs.libsForQt5.qt5.qtgraphicaleffects
        pkgs.libsForQt5.qt5.qtsvg
    ];
  };
}

