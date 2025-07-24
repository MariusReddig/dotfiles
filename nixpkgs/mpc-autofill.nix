{ stdenv, fetchurl, pkgs, buildFHSEnv }:

let
  baseApp = stdenv.mkDerivation rec {
    pname = "autofill-linux-base";
    version = "4.5.2";

    src = fetchurl {
      url = "https://github.com/chilli-axe/mpc-autofill/releases/download/v${version}/autofill-linux";
      sha256 = "m8qcw1n2h7w1ItU04Eu6vRUpQMSmkuP+4KCIXu1KbEQ="; # Replace with actual hash
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [
      pkgs.glibc
      pkgs.zlib
      pkgs.readline
      pkgs.dbus
    ];

    installPhase = ''
      install -Dm755 $src $out/bin/autofill-linux
    '';

    dontUnpack = true;
  };

  fhsEnv = buildFHSEnv {
    name = "autofill-linux";

    targetPkgs = pkgs: [
      baseApp
      pkgs.python3
      pkgs.glibc
      pkgs.zlib
      pkgs.readline
      pkgs.dbus
      pkgs.chromium
      pkgs.gtk3
      pkgs.xorg.libX11
    ];

    runScript = "${baseApp}/bin/autofill-linux";

    extraBwrapArgs = [
      "--bind /tmp /tmp"  # Allow writing to /tmp
      "--bind ~/.cache ~/.cache"  # Allow writing to user cache
      "--bind ~/.config ~/.config"  # Allow writing to user config
    ];

    meta = with pkgs.lib; {
      description = "MTG Card printing software";
      homepage = "https://mpcfill.com/";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
    };
  };

in fhsEnv
