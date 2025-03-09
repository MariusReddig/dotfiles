{ pkgs, pkgs-unstable, ... }:
{
  home = {
    username = "marius";
    homeDirectory = "/home/marius";
    stateVersion = "24.11";
  };

  zsh.enable = true;
  nvim.enable = true;

  imports = [
    ./../home-modules
    ./../theming
  ];

  theming.enable = true;
  theming.theme = "hyprland-oni";

  # Packages
  home.packages =
    (with pkgs; [
      lutris-unwrapped
      stow
      anki
      firefox
      thunderbird
      bitwarden
      kitty
      xournalpp
      vesktop
      thunderbird
      nextcloud-client
      superfile
      kdePackages.gwenview
      vlc
      kdePackages.phonon-vlc
      kdePackages.phonon
      kdePackages.qtimageformats
      grim
      scrcpy
      android-tools
      qview
      swayimg
      feh
      signal-desktop
      amdgpu_top
      lact
      krita
      prismlauncher
    ])
    ++
    (with pkgs-unstable; [
      ryujinx
    ]);

  home.sessionVariables = {
    XDG_DATA_HOME = "/home/marius/.local/share/";
    XDG_BACKEND = "x11";
  };

  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
