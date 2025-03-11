{ pkgs, pkgs-unstable, username, config, lib, ... }:
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  zsh.enable = true;
  # nvim.enable = true;

  imports = [
    ./zsh.nix
  ];

  # theming.enable = true;
  # theming.theme = "hyprland-oni";

  # Packages
  home.packages =
    (with pkgs; [
	# System Utilities
	# gcc
	man-pages-posix
	man-pages
	usbutils
	unzip
	stow
	android-tools
	scrcpy
	xdg-user-dirs
	xdg-user-dirs-gtk
	firewalld

	# System Monitoring
	htop
	btop
	amdgpu_top
	lact
	upower
	fastfetch

	# Fonts
	noto-fonts

	# Audio/Video Control
	pavucontrol
	pamixer
	easyeffects
	vlc
	kdePackages.phonon-vlc
	kdePackages.phonon
	kdePackages.qtimageformats

	# File Management
	fd
	superfile
	qview
	swayimg
	feh

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

	# Streaming films and series
	stremio

	# Graphics and Design
	krita
	kdePackages.gwenview
	swappy
	qt6ct
	lxappearance
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
	discord
	vesktop
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
    ".config/dunst".source = ./dunst;
    ".config/hypr".source = ./hyprland;
    ".config/kitty".source = ./kitty;
    ".config/Thunar".source = ./thunar;
    ".config/waybar".source = ./waybar;
    ".config/wofi".source = ./wofi;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
