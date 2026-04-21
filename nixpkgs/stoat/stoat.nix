{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "stoat-desktop";
  version = "1.3.0";

  src = pkgs.fetchurl {
    url =
      "https://github.com/stoatchat/for-desktop/releases/download/v${version}/Stoat-linux-x64-${version}.zip";
    hash = "sha256-n4dfAHWJ2Tv1lKvGDGUIA9oaGK1IpLI3ZrX5y379/TQ=";
  };

  nativeBuildInputs = with pkgs; [
    unzip
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "stoat";
      exec = "stoat %U";
      icon = "stoat";
      desktopName = "Stoat";
      comment = meta.description;
      categories = [ "Network" "InstantMessaging" "Chat" ];
      mimeTypes = [ "x-scheme-handler/stoat" ];
    })
  ];

  buildInputs = with pkgs; [
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libgbm
    libxcb
    libxkbcommon
    mesa
    nspr
    nss
    pango
    udev
    wayland
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r * $out/

    # Install desktop item
    for desktopItem in $desktopItems; do
      mkdir -p $out/share/applications
      cp $desktopItem/share/applications/* $out/share/applications/
    done

    makeWrapper $out/Stoat-linux-x64/stoat-desktop $out/bin/stoat

    runHook postInstall
  '';

  # Try to find and install icon if it exists in the package
  postInstall = ''
    # Look for icons in various locations
    if [ -d "$out/Stoat-linux-x64/resources" ]; then
      mkdir -p $out/share/icons/hicolor/{16x16,32x32,48x48,64x64,128x128,256x256}/apps

      # Try to find any icon files
      find "$out" -name "*.png" -o -name "*.svg" -o -name "*.ico" 2>/dev/null | while read icon; do
        case "$icon" in
          *16x16*.png|*16.png|*icon16*)
            cp "$icon" $out/share/icons/hicolor/16x16/apps/stoat.png 2>/dev/null || true
            ;;
          *32x32*.png|*32.png|*icon32*)
            cp "$icon" $out/share/icons/hicolor/32x32/apps/stoat.png 2>/dev/null || true
            ;;
          *48x48*.png|*48.png|*icon48*)
            cp "$icon" $out/share/icons/hicolor/48x48/apps/stoat.png 2>/dev/null || true
            ;;
          *64x64*.png|*64.png|*icon64*)
            cp "$icon" $out/share/icons/hicolor/64x64/apps/stoat.png 2>/dev/null || true
            ;;
          *128x128*.png|*128.png|*icon128*)
            cp "$icon" $out/share/icons/hicolor/128x128/apps/stoat.png 2>/dev/null || true
            ;;
          *256x256*.png|*256.png|*icon256*)
            cp "$icon" $out/share/icons/hicolor/256x256/apps/stoat.png 2>/dev/null || true
            ;;
          *.svg)
            cp "$icon" $out/share/icons/hicolor/scalable/apps/stoat.svg 2>/dev/null || true
            ;;
        esac
      done
    fi
  '';

  meta = with pkgs.lib; {
    description = "Open source user-first chat platform";
    homepage = "https://stoat.chat/";
    changelog =
      "https://github.com/stoatchat/for-desktop/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ heyimnova magistau ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "stoat";
  };
}
