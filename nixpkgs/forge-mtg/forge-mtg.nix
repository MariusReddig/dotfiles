{
  coreutils,
  fetchFromGitHub,
  gnused,
  lib,
  maven,
  makeWrapper,
  openjdk,
}:

let
  version = "2.0.06";

  src = fetchFromGitHub {
    owner = "Card-Forge";
    repo = "forge";
    rev = "forge-${version}";
    hash = "sha256-T75UqzEuHEssARcRldTCTyNuZnILPlNJesD+l6RGX4g=";
    leaveDotGit = true;
  };

  # launch4j downloads and runs a native binary during the package phase.
  patches = [ ./no-launch4j.patch ];

  createDesktopEntry = name: description: ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/forge-${name}.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=${description}
    Exec=$out/share/forge/${name}.sh
    Icon=$out/share/forge/res/skins/default/hd_logo.png
    Categories=Game;
    EOF
  '';


in
maven.buildMavenPackage {
  pname = "forge-mtg";
  inherit version src patches; #

  mvnHash = "sha256-ThzU0ZSHlfZ3wvVo/jUx/ahS8h9Zid0SUHQz29lO6xI=";

  doCheck = false; # Needs a running Xorg

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/forge
    cp -r forge-gui/res $out/share/forge/

    cp adventure-editor/target/adventure-editor.sh $out/share/forge/forge-adventure-editor.sh
    cp adventure-editor/target/adventure-editor-jar-with-dependencies.jar $out/share/forge/

    cp forge-gui-mobile-dev/target/forge-adventure.sh $out/share/forge/
    cp forge-gui-mobile-dev/target/forge-gui-mobile-dev-${version}-jar-with-dependencies.jar $out/share/forge/

    # NOTE adventure-mode currently not working
    #{createDesktopEntry "forge-adventure-editor" "Forge Adventure Editor"}
    #{createDesktopEntry "forge-adventure" "Forge Adventure"}

    cp forge-gui-desktop/target/forge.sh $out/share/forge/
    cp forge-gui-desktop/target/forge-gui-desktop-${version}-jar-with-dependencies.jar $out/share/forge/
    ${createDesktopEntry "forge" "Forge MTG"}



     # Create a symlink target in ~/.config/forge/themes
    mkdir -p $out/share/forge/res/skins  # Ensure themes dir exists in the package
    ln -sfT "$HOME/.config/forge/themes" "$out/share/forge/res/skins/user-themes"

    runHook postInstall
  '';

  preFixup = ''
    for commandToInstall in forge forge-adventure forge-adventure-editor; do
      chmod 555 $out/share/forge/$commandToInstall.sh
      makeWrapper $out/share/forge/$commandToInstall.sh $out/bin/$commandToInstall \
        --prefix PATH : ${
          lib.makeBinPath [
            coreutils
            openjdk
            gnused
          ]
        } \
        --set JAVA_HOME ${openjdk}/lib/openjdk \
        --set SENTRY_DSN ""
    done
  '';

  meta = with lib; {
    description = "Magic: the Gathering card game with rules enforcement";
    homepage = "https://www.slightlymagic.net/forum/viewforum.php?f=26";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ eigengrau ];
  };
}
