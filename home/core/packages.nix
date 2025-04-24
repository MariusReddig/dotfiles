{ pkgs, pkgs-unstable, inputs, username, config, nix-citizen, system, ... }:
{
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

      # System Monitoring
      htop
      btop
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
      helvum
      pavucontrol
      pamixer
      easyeffects
      vlc
      kdePackages.phonon-vlc
      kdePackages.phonon
      kdePackages.qtimageformats

      # File Management
      superfile
      qview
      fd

      # Productivity
      anki
      xournalpp
      signal-desktop
      whatsapp-for-linux
      bitwarden
      thunderbird
      nextcloud-client

      # Streaming films and series
      stremio

      # Graphics and Design
      inkscape
      krita
      swappy

      # Terminal and Shell
      kitty

      # Hyprland
      hyprpicker
      grim
      slurp
      waybar
      waybar-mpris
      wofi
      dunst
      wl-clipboard
      cliphist
      swww

      # Communication
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
        # vencord = equicord;
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
    (with pkgs-unstable; [
    ])
    ++
    (with inputs; [
      pferd.packages.${pkgs.system}.default
    ]);
}
