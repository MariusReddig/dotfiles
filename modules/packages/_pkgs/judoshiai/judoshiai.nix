{ pkgs, ... }:

let
  # The upstream .deb was built against Debian's libxml2 (SONAME libxml2.so.2)
  # and Debian's patched lua5.4 (SONAME liblua5.4.so.0). nixpkgs ships the
  # same ABI under different SONAMEs, so autoPatchelf needs a nudge via
  # symlinks under these names.
  compatLibs = pkgs.runCommand "judoshiai-compat-libs" { } ''
    mkdir -p $out/lib
    ln -s ${pkgs.libxml2.out}/lib/libxml2.so.16 $out/lib/libxml2.so.2
    ln -s ${pkgs.lua5_4}/lib/liblua.so.5.4 $out/lib/liblua5.4.so.0
  '';
in
pkgs.stdenv.mkDerivation rec {
  pname = "judoshiai";
  version = "4.4.1-1";

  src = pkgs.fetchurl {
    url = "https://sourceforge.net/projects/judoshiai/files/Linux-x86_64/judoshiai_${version}_amd64.deb/download";
    hash = "sha256-ud5TWoKeKaLf2a1JXs4oiBsjeRSOMe+BycnJ/LlVRho=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    gtk3
    glib
    cairo
    pango
    atk
    gdk-pixbuf
    librsvg
    curl
    libssh2
    gnutls
    libxml2
    libuv
    libcap
    lua5_4
    libao
    libmpg123
    compatLibs
  ];

  # It's a flat Debian package, not a tarball - unpack with dpkg-deb instead.
  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/bin $out/share
    cp -r usr/lib/judoshiai $out/lib/judoshiai
    cp -r usr/share/applications $out/share/applications
    cp -r usr/share/icons $out/share/icons
    cp -r usr/share/mime $out/share/mime

    for prog in judoshiai judoinfo judojudogi judotimer judoweight db-convert; do
      ln -s $out/lib/judoshiai/programs/$prog $out/bin/$prog
    done

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Software for managing and running judo tournaments";
    homepage = "https://www.judoshiai.org/";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "judoshiai";
  };
}
