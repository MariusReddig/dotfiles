{ pkgs }:
{
   judo-shiai = pkgs.stdenv.mkDerivation rec {
    name = "judo-shiai";
    src = ./deb/judoshiai_4.4-1_amd64.deb;
    nativeBuildInputs = with pkgs; [ dpkg autoPatchelfHook ];
    buildInputs = with pkgs; [
      libuv
      steam-run
      libcap
      lua5_4
      gtk3
      pango
      glib
      cairo
      librsvg
      gdk-pixbuf
      curl
      mpg123
      libao
    ];
    unpackPhase = ''
      dpkg-deb -x $src .
      '';
    installPhase =  ''
      mkdir -p $out
      cp -r ./* $out/

      # Create compatibility symlink
      mkdir -p $out/usr/lib
      ln -sf ${pkgs.lua5_4}/lib/liblua.so.5.4 $out/usr/lib/liblua5.4.so.0
    '';
       # Ensure the symlink is found during patchelf
    preFixup = ''
      addAutoPatchelfSearchPath $out/usr/lib
    '';
    # postInstall = ''
    #   wrapProgram $out/usr/bin/judoshiai --prefix PATH : ${pkgs.steam-run}/bin
    # '';
  };

}
