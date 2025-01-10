{ pkgs, ... }:

{
  home = {
    username = "marius";
    homeDirectory = "/home/marius";
    stateVersion = "24.11";
  };

  zsh.enable = true;
  mullvad.enable = true;
  thunar.enable = true;
  nvim.enable = true;

  imports = [
    ./../../home-modules
    ./hyprland/default-theme.nix
  ];

  # Packages
  home.packages = with pkgs; [
    anki
    firefox
    thunderbird
    bitwarden
    kitty
    xournalpp
    vesktop
    fastfetch
    git
    thunderbird
    nextcloud-client
    lxappearance
    xdg-user-dirs
    xdg-user-dirs-gtk
    baobab
    swappy
    superfile
    xplr
    kdePackages.gwenview
    btop
    htop
    vlc
    kdePackages.phonon-vlc
    kdePackages.phonon
    kdePackages.qtimageformats
    ryujinx-greemdev
    qt6ct
    file-roller
    scrcpy
    android-tools
    grim
    qview
    swayimg
    slurp
    wl-clipboard
    feh
    gcr
  ];

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
