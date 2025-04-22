{ pkgs }:
{
  think10-plymouth-theme = pkgs.stdenv.mkDerivation rec {
    name = "think10-plymouth-theme";
    src = pkgs.fetchFromGitHub {
      owner = "gevera";
      repo = "plymouth_themes";
      rev = "afdf22e630ad516676fc3253305a225f8651ac6e";
      sha256 = "0xkjmqax2s04avzj8pjxlvy3j86934h3h15s0z8fafwcfggjrj8s";
    };
    installPhase = ''
        mkdir -p $out/share/plymouth/themes
        cp -aR thinkpad/think10 $out/share/plymouth/themes/
        substituteInPlace $out/share/plymouth/themes/think10/think10.plymouth \
          --replace "/usr" "$out"
      '';
  };
  thinkdar-plymouth-theme = pkgs.stdenv.mkDerivation rec {
    name = "thinkpad-plymouth-theme";
    src = pkgs.fetchFromGitHub {
      owner = "gevera";
      repo = "plymouth_themes";
      rev = "afdf22e630ad516676fc3253305a225f8651ac6e";
      sha256 = "0xkjmqax2s04avzj8pjxlvy3j86934h3h15s0z8fafwcfggjrj8s";
    };
    installPhase = ''
        mkdir -p $out/share/plymouth/themes
        cp -aR thinkpad/thinkdar $out/share/plymouth/themes/
        substituteInPlace $out/share/plymouth/themes/thinkdar/thinkdar.plymouth \
          --replace "/usr" "$out"
      '';
  };

}

