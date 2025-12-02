{ pkgs, inputs, nixpkgs, ... }: {
  programs.btop.enable = true;
  home.packages = (with pkgs; [
    # German e-ID card authentication app
    openvpn
    networkmanager-openvpn
    # ausweisapp

    jdupes

    #Judo-shiai
    # (callPackage ../../nixpkgs/packages.nix {}).judo-shiai

    # System Utilities
    man-pages-posix
    man-pages
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
    qalculate-qt

    # System Monitoring
    amdgpu_top
    lact
    upower
    fastfetch

    # Fonts
    corefonts
    noto-fonts
    noto-fonts-cjk-sans

    papirus-icon-theme
    ipafont

    # Audio/Video Control
    helvum
    pavucontrol
    pamixer
    easyeffects
    vlc
    kdePackages.phonon-vlc
    kdePackages.phonon
    kdePackages.qtimageformats

    # Productivity
    anki
    xournalpp
    uair
    rnote
    signal-desktop
    wasistlos
    bitwarden-desktop
    thunderbird
    nextcloud-client
    libreoffice-still
    gh
    gh-notify
    hub
    # chromium
    texlive.combined.scheme-basic
    # unstable.mathematica

    # # Streaming films and series
    # stremio update qt library to QT6
    cozy

    # File Management
    qview
    # fd

    # Graphics and Design
    inkscape
    krita
    swappy

    # Hyprland
    hyprpicker
    grim
    slurp
    waybar
    waybar-mpris
    # wofi
    wl-clipboard
    cliphist

    # Communication
    # (discord.override {
    #   # withOpenASAR = true;
    #   # withVencord = true;
    # })
    vesktop
    element-desktop

    # Development Tools
    python312Packages.pip
    clang

    # Network Management
    blueman
    networkmanagerapplet

    # Notifications
    libnotify
  ]) ++ (with inputs; [ swww.packages.${pkgs.system}.swww ]);
}
