{ coreutils, fetchFromGitHub, gnused, lib, stdenv, maven, makeWrapper, openjdk
, libGL, alsa-lib, makeDesktopItem, copyDesktopItems, imagemagick
, nix-update-script, }:

let
  # Version is now derived from the source date
  version = "2.0.09-daily-snapshot";

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    # Use the tag, not the branch
    rev = "master"; # This is a permanent tag on the releases page[citation:1]
    hash = "sha256-RCAPNevo5yzxAJsBdZoGaqMk0dN9lH1L9vJbWtAQa30=";
  };

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./no-launch4j.patch ];

in maven.buildMavenPackage {
  pname = "forge-mtg";
  inherit version src patches;

  mvnHash = "sha256-pa6OMCN1j1l4Kb0oiRQ8ocLLNMeV3ujOeXNpWcODArA=";

  doCheck = false; # Needs a running Xorg

  nativeBuildInputs = [ makeWrapper copyDesktopItems imagemagick ];
  desktopItems = [
    (makeDesktopItem {
      name = "forge";
      exec = "forge";
      actions = {
        forge-adventure = {
          exec = "forge-adventure";
          name = "Play Adventure";
        };
        forge-adventure-editor = {
          exec = "forge-adventure-editor";
          name = "Adventure Editor";
        };
        forge-classic = {
          exec = "forge";
          name = "Play Classic";
        };
      };
      icon = "forge-mtg";
      comment = "Magic: the Gathering card game with rules enforcement";
      desktopName = "Forge MTG";
      genericName = "Card Game";
      categories = [ "Game" "BoardGame" ];
      keywords = [ "Magic" "MTG" "Card Game" "Trading Card Game" "TCG" ];
    })
  ];

  mvnParameters = lib.escapeShellArgs [
    "-pl"
    ":adventure-editor,:forge-gui-desktop,:forge-gui-mobile-dev"
    "--also-make"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/forge

    # Find the actual jar files (they may have different version numbers)
    FORGE_JAR=$(find forge-gui-desktop/target -name "forge-gui-desktop*.jar" -not -name "*sources*" -not -name "*javadoc*" | head -1)
    ADVENTURE_JAR=$(find forge-gui-mobile-dev/target -name "forge-gui-mobile-dev*.jar" -not -name "*sources*" -not -name "*javadoc*" | head -1)
    EDITOR_JAR=$(find adventure-editor/target -name "adventure-editor*.jar" -not -name "*sources*" -not -name "*javadoc*" | head -1)

    # Copy files
    cp -a \
      forge-gui-desktop/target/forge.sh \
      "$FORGE_JAR" \
      forge-gui-mobile-dev/target/forge-adventure.sh \
      "$ADVENTURE_JAR" \
      "$EDITOR_JAR" \
      forge-gui/res \
      $out/share/forge
    cp adventure-editor/target/adventure-editor.sh $out/share/forge/forge-adventure-editor.sh

    mkdir -p $out/share/icons/hicolor/128x128/apps
    magick AppIcon.png -resize 128x128 $out/share/icons/hicolor/128x128/apps/forge-mtg.png

    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure forge-adventure-editor; do
      chmod 555 $out/share/forge/$commandToInstall.sh
      PREFIX_CMD=""
      if [ "$commandToInstall" = "forge-adventure" ]; then
        PREFIX_CMD="--prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath ([ libGL ]
            ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform alsa-lib)
            [ alsa-lib ])
        }"
      fi

      makeWrapper $out/share/forge/$commandToInstall.sh $out/bin/$commandToInstall \
        --prefix PATH : ${lib.makeBinPath [ coreutils openjdk gnused ]} \
        --set JAVA_HOME ${openjdk}/lib/openjdk \
        --set SENTRY_DSN "" \
        $PREFIX_CMD
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://card-forge.github.io/forge";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dyegoaurelio eigengrau ];
  };
}
