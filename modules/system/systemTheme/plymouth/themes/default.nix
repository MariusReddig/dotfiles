{
  # Both themes as flake packages: self'.packages.think10-plymouth-theme / thinkdar-plymouth-theme
  perSystem =
    { pkgs, lib, ... }:
    let
      src = pkgs.fetchFromGitHub {
        owner = "gevera";
        repo = "plymouth_themes";
        rev = "afdf22e630ad516676fc3253305a225f8651ac6e";
        sha256 = "0xkjmqax2s04avzj8pjxlvy3j86934h3h15s0z8fafwcfggjrj8s";
      };
      mkTheme =
        theme:
        pkgs.stdenv.mkDerivation {
          name = "${theme}-plymouth-theme";
          inherit src;
          installPhase = ''
            mkdir -p $out/share/plymouth/themes
            cp -aR thinkpad/${theme} $out/share/plymouth/themes/
            substituteInPlace $out/share/plymouth/themes/${theme}/${theme}.plymouth \
              --replace-fail "/usr" "$out"
          '';
        };
    in
    {
      packages = {
        think10-plymouth-theme = mkTheme "think10";
        thinkdar-plymouth-theme = mkTheme "thinkdar";
      };
    };
}
