{ stdenv, sddm-astronaut }:

stdenv.mkDerivation {
  pname = "japanese-aesthetic-sddm-theme";
  version = "1.0";

  src = sddm-astronaut;

  installPhase = ''
    THEME="$out/share/sddm/themes/japanese-aesthetic"
    SRC_THEME="$src/share/sddm/themes/sddm-astronaut-theme"

    mkdir -p "$THEME/Themes"

    # Copy only the necessary files
    cp -r "$SRC_THEME/Assets" "$THEME/"
    cp -r "$SRC_THEME/Backgrounds" "$THEME/"
    cp -r "$SRC_THEME/Components" "$THEME/"
    cp -r "$SRC_THEME/Fonts" "$THEME/"
    cp "$SRC_THEME/Main.qml" "$THEME/"
    cp "$SRC_THEME/metadata.desktop" "$THEME/"

    # Copy only the desired theme
    cp -r "$SRC_THEME/Themes/japanese_aesthetic.conf" "$THEME/Themes/"

    # Patch metadata to point to the theme config
    sed -i 's|ConfigFile=.*|ConfigFile=Themes/japanese_aesthetic.conf|' \
      "$THEME/metadata.desktop"
  '';
}

