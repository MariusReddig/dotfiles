{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "marius";
  home.homeDirectory = "/home/marius";
  home.stateVersion = "24.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
	file-roller
	baobab
	nautilus
	loupe
	inkscape
  ];
	
	imports = [
		../../../themes/hyprland-default.nix
	];

  home.sessionVariables = {
    EDITOR = "nvim";
		XDG_DATA_HOME = "/home/marius/.local/share/";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
