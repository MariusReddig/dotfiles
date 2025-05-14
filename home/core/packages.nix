{ pkgs, inputs, ... }:
{
  programs.btop.enable = true;
  home.packages =
    (with pkgs; [
      # German e-ID card authentication app
      ausweisapp

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
      firewalld
      cmake
      playerctl

      # System Monitoring
      amdgpu_top
      lact
      upower
      fastfetch

      # Fonts
      corefonts
      noto-fonts
      noto-fonts-cjk-sans

      noto-fonts-extra
      ipafont

      # Audio/Video Control
      # helvum
      pavucontrol
      pamixer
      easyeffects
      vlc
      kdePackages.phonon-vlc
      kdePackages.phonon
      kdePackages.qtimageformats

      # File Management
      unstable.superfile
      qview
      fd

      # Productivity
      anki
      xournalpp
      rnote
      signal-desktop
      whatsapp-for-linux
      bitwarden
      thunderbird
      nextcloud-client
      unstable.mathematica

      # Streaming films and series
      stremio

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
      wofi
      wl-clipboard
      cliphist

      # Communication
      (unstable.discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      element-desktop

      # Development Tools
      python312Packages.pip
      clang
      jdk21
      # jdk8

      # Network Management
      blueman
      networkmanagerapplet

      # Notifications
      libnotify
    ])
    ++
    (with inputs; [
      swww.packages.${pkgs.system}.swww
    ]);
}
