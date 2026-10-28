{ pkgs, inputs, ... }: {
  programs.btop.enable = true;
  home.packages =
    (with pkgs; [
      quickshell

      # System Utilities
      usbutils
      unzip
      android-tools
      scrcpy
      xdg-user-dirs
      xdg-user-dirs-gtk
      p7zip
      unstable.firewalld-gui
      imagemagick
      direnv
      python312Packages.pyqt6
      pwvucontrol
      dwt1-shell-color-scripts
      cmake
      playerctl
      jdupes
      qalculate-qt

      # System Monitoring
      amdgpu_top
      lact
      upower
      fastfetch
      unstable.openrgb-with-all-plugins

      # Fonts
      corefonts
      noto-fonts
      noto-fonts-cjk-sans
      papirus-icon-theme
      ipafont

      # Audio/Video Control
      crosspipe
      pavucontrol
      easyeffects
      kdePackages.qtimageformats

      # Productivity
      anki
      xournalpp
      uair
      signal-desktop
      zapzap
      thunderbird
      nextcloud-client
      libreoffice-still
      gh
      gh-notify
      hub
      texlive.combined.scheme-basic

      # # Streaming films and series
      stremio-linux-shell
      cozy

      # File Management
      qimgv

      # Graphics and Design
      inkscape
      krita
      swappy

      # Hyprland
      grim
      slurp
      waybar
      waybar-mpris
      wl-clipboard
      cliphist

      # Communication
      legcord
      unstable.fluxer
      # (callPackage ../../nixpkgs { }).stoat

      # Development Tools
      python312Packages.pip
      clang

      # Network Management
      blueman
      networkmanagerapplet

      # Notifications
      libnotify
    ])
    ++ (with inputs; [ awww.packages.${pkgs.stdenv.hostPlatform.system}.awww ]);
  xdg.desktopEntries = {
    signal = {
      name = "Signal";
      exec = "signal-desktop --disable-features=WaylandFractionalScaleV1 %U";
      icon = "signal-desktop";
    };
    legcord = {
      name = "Legcord";
      exec = "legcord --disable-features=WaylandFractionalScaleV1 %U";
      icon = "legcord";
    };
  };
}
