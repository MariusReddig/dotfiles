{ config, pkgs, lib, ... }:

{
  options = { ubisoft.enable = lib.mkEnableOption "enable ubisoft module"; };

  config = lib.mkIf config.ubisoft.enable {

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "ubisoft-install" ''
        #!/usr/bin/env bash
        set -euo pipefail

        echo "=== Ubisoft Connect Installer ==="
        echo ""

        COMPAT_DIR="$HOME/.steam/steam/steamapps/compatdata/ubisoft-connect"
        INSTALLER="/tmp/UbisoftConnectInstaller.exe"
        INSTALL_PATH="$COMPAT_DIR/pfx/drive_c/Program Files (x86)/Ubisoft/Ubisoft Game Launcher/UbisoftConnect.exe"

        # Clean previous failed attempts
        rm -rf "$COMPAT_DIR"
        mkdir -p "$COMPAT_DIR"

        # Download installer
        echo "📥 Downloading installer..."
        curl -L "https://ubistatic3-a.akamaihd.net/orbit/launcher_installer/UbisoftConnectInstaller.exe" \
          -o "$INSTALLER" \
          --progress-bar

        # Check for Proton
        PROTON_DIR="$HOME/.steam/steam/compatibilitytools.d/GE-Proton10-26"
        if [ ! -d "$PROTON_DIR" ]; then
          echo "❌ Proton GE not found!"
          echo "Download from: https://github.com/GloriousEggroll/proton-ge-custom"
          echo "Extract to: ~/.steam/steam/compatibilitytools.d/"
          exit 1
        fi

        echo "🚀 Running installer with $(basename "$PROTON_DIR")..."
        echo "⚠️  IMPORTANT: Complete the installation wizard when it opens!"
        echo "   Click 'Install' and wait for it to finish."
        echo ""

        # Run installer and WAIT for it
        ${steam-run}/bin/steam-run bash -c "
          cd '$COMPAT_DIR'
          export STEAM_COMPAT_DATA_PATH='$COMPAT_DIR'
          export STEAM_COMPAT_CLIENT_INSTALL_PATH='$HOME/.steam/steam'

          # Run installer and wait
          '$PROTON_DIR/proton' run '$INSTALLER' &
          INSTALLER_PID=\$!

          # Wait for installer process
          wait \$INSTALLER_PID
          echo 'Installer process finished.'
        "

        # Wait a bit for files to be written
        sleep 5

        # Check if installed
        echo ""
        echo "🔍 Checking installation..."

        if [ -f "$INSTALL_PATH" ]; then
          echo "✅ Installation successful!"
          echo "📁 Location: $INSTALL_PATH"
        else
          echo "⚠️  Installer ran but files not found."
          echo "Trying alternative paths..."

          # Search for executable
          find "$COMPAT_DIR" -name "*.exe" -type f | grep -i ubisoft | head -5

          echo ""
          echo "Possible issues:"
          echo "1. Installation was canceled"
          echo "2. Installer needs admin rights"
          echo "3. Different installation path"

          # Try Wine directly as fallback
          echo ""
          read -p "Try direct Wine installation? (y/N) " -n 1 -r
          echo
          if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Installing with Wine directly..."
            WINEPREFIX="$COMPAT_DIR/pfx" ${wine}/bin/wine "$INSTALLER"
          fi
        fi

        echo ""
        echo "📝 To add to Steam:"
        echo "1. Open Steam"
        echo "2. Games → Add a Non-Steam Game"
        echo "3. Click 'Browse'"
        echo "4. Navigate to: $COMPAT_DIR/pfx/drive_c/"
        echo "5. Find and select UbisoftConnect.exe"
      '')

      # Alternative: Direct install with Wine
      (writeShellScriptBin "ubisoft-install-direct" ''
        #!/usr/bin/env bash
        echo "Installing Ubisoft Connect directly with Wine..."

        COMPAT_DIR="$HOME/.steam/steam/steamapps/compatdata/ubisoft-connect"
        rm -rf "$COMPAT_DIR"
        mkdir -p "$COMPAT_DIR"

        # Download installer
        INSTALLER="/tmp/uc_install.exe"
        curl -L "https://ubistatic3-a.akamaihd.net/orbit/launcher_installer/UbisoftConnectInstaller.exe" \
          -o "$INSTALLER" --progress-bar

        # Install with wine
        echo "⚠️  Complete the installation wizard!"
        echo "   Default installation path is fine."
        echo ""

        ${steam-run}/bin/steam-run bash -c "
          cd '$COMPAT_DIR'
          WINEPREFIX='$PWD/pfx' ${wine}/bin/wine '$INSTALLER'
        "

        # Check result
        if [ -f "$COMPAT_DIR/pfx/drive_c/Program Files (x86)/Ubisoft/Ubisoft Game Launcher/UbisoftConnect.exe" ]; then
          echo "✅ Success!"
        else
          echo "Check: $COMPAT_DIR/pfx/drive_c/"
          find "$COMPAT_DIR" -name "*.exe" -type f
        fi
      '')

      # Manual installer that shows what to do
      (writeShellScriptBin "ubisoft-install-manual" ''
        #!/usr/bin/env bash
        echo "=== Manual Ubisoft Connect Setup ==="
        echo ""
        echo "1. First, install Proton GE if not already:"
        echo "   Download from: https://github.com/GloriousEggroll/proton-ge-custom"
        echo "   Extract to: ~/.steam/steam/compatibilitytools.d/"
        echo ""
        echo "2. Run this command to download installer:"
        echo "   curl -L https://ubi.li/4vxt9 -o ~/Downloads/UbisoftConnectInstaller.exe"
        echo ""
        echo "3. Install via Steam:"
        echo "   - Open Steam"
        echo "   - Add Non-Steam Game"
        echo "   - Browse to ~/Downloads/UbisoftConnectInstaller.exe"
        echo "   - Add it"
        echo "   - Right-click → Properties → Compatibility"
        echo "   - Check 'Force compatibility tool'"
        echo "   - Select 'GE-Proton10-26'"
        echo "   - Launch it from Steam to install"
        echo ""
        echo "4. After installation:"
        echo "   - Find where it installed (usually in the compatdata folder)"
        echo "   - Add the actual UbisoftConnect.exe to Steam"
        echo ""
        echo "Or use the experimental auto-installer: ubisoft-install-experimental"
      '')

      # Experimental: Use protontricks to install
      (writeShellScriptBin "ubisoft-install-experimental" ''
        #!/usr/bin/env bash
        # Install using protontricks

        echo "Creating new Steam app for Ubisoft Connect..."

        # Create a dummy app ID
        APPID=1234567890
        COMPAT_DIR="$HOME/.steam/steam/steamapps/compatdata/$APPID"

        # Download installer
        INSTALLER="/tmp/ubisoft_setup.exe"
        curl -L "https://ubi.li/4vxt9" -o "$INSTALLER" --progress-bar

        # Use steam-run with wine
        ${steam-run}/bin/steam-run bash -c "
          # Set up prefix
          export WINEPREFIX='$COMPAT_DIR/pfx'
          export WINEARCH=win64

          # Run installer
          ${wine}/bin/wine '$INSTALLER'

          echo 'After installation, find the .exe at:'
          echo '$COMPAT_DIR/pfx/drive_c/Program Files (x86)/Ubisoft/Ubisoft Game Launcher/'
        "

        echo ""
        echo "To add to Steam, browse to the above path and select UbisoftConnect.exe"
      '')
    ];
  };
}
