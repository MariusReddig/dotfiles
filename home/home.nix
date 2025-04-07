{ pkgs, pkgs-unstable, username, config, lib, ... }:
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  zsh.enable = true;

  imports = [
    ./zsh.nix
    ./nvim/nvim.nix
    ./tmux/tmux.nix
    ./obs.nix
    ./eza.nix
  ];

  # theming.enable = true;
  # theming.theme = "hyprland-oni";

  # Packages
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
      noto-fonts-emoji
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
      swayimg
      feh
      fd

      # Productivity
      anki
      xournalpp
      signal-desktop
      bitwarden
      thunderbird
      nextcloud-client

      # Web Browsers
      firefox

      # Gaming
      prismlauncher
      lutris


      # Streaming films and series
      stremio

      # Graphics and Design
      krita
      kdePackages.gwenview
      swappy
      qt6ct
      nwg-look
      capitaine-cursors
      morewaita-icon-theme
      gnome-themes-extra

      # Terminal and Shell
      kitty

      # Hyprland
      hyprpicker
      swww
      grim
      slurp
      waybar
      waybar-mpris
      wofi
      dunst
      wl-clipboard
      cliphist

      # Communication
      (discord.override {
        withOpenASAR = true;
        # withVencord = true;
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

      # Fonts
      nerd-fonts.jetbrains-mono

      # Gaming
      ryujinx
    ]);

  home.sessionVariables = {
    XDG_DATA_HOME = "/home/${username}/.local/share/";
    XDG_BACKEND = "x11";
    EDITOR = "nvim";
    VISUAL = "firefox";
    MANPAGER = "nvim +Man!";
  };

  # plain files is through 'home.file'.
  #TODO: Make individual nix configs for the configurations below!
  home.file = {
    # ".config/dunst".source = ./dunst;
    # ".config/hypr".source = ./hyprland;
    # ".config/kitty".source = ./kitty;
    # ".config/Thunar".source = ./thunar;
    # ".config/waybar".source = ./waybar;
    # ".config/wofi".source = ./wofi;
  };

    home.activation.linkDotFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T ~/nix/home/dunst     ~/.config/dunst
    ln -sfr -T ~/nix/home/hyprland  ~/.config/hypr
    ln -sfr -T ~/nix/home/kitty     ~/.config/kitty
    ln -sfr -T ~/nix/home/thunar    ~/.config/Thunar
    ln -sfr -T ~/nix/home/waybar    ~/.config/waybar
    ln -sfr -T ~/nix/home/wofi      ~/.config/wofi
    ln -sfr -T ~/nix/home/.editorconfig      ~/.editorconfig
    '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
