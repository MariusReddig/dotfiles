{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "marius";
  home.homeDirectory = "/home/marius";
  home.stateVersion = "24.11";

  # Packages
  nixpkgs.overlays = [ inputs.polymc.overlay ]; # needed to ad polymc to packages
  home.packages = with pkgs; [
    stow
    xfce.thunar
    firefox
    thunderbird
    bitwarden
    kitty
    xournalpp
    vesktop
    wofi
    fastfetch
    git
    thunderbird
    nextcloud-client
    imagemagick
    lxappearance
    xdg-user-dirs
    xdg-user-dirs-gtk
    baobab
    inkscape
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
    polymc
    android-tools
    grim
    qview
    swayimg
    slurp
    wl-clipboard
    feh
    gcr
  ];

	imports = [
		../../../themes/hyprland-default.nix
	];

  home.sessionVariables = {
    EDITOR = "nvim";
		XDG_DATA_HOME = "/home/marius/.local/share/";
		XDG_BACKEND = "x11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
