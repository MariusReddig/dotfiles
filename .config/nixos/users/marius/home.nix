{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "marius";
  home.homeDirectory = "/home/marius";
  home.stateVersion = "24.11"; 

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
  xfce.thunar
  neovim
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
  swww
  ];

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

  #enable Qt
  #qt.enable = true;
  #qt.platformTheme = "gtk";
  #qt.style.name    = "adwaita-dark";
  #qt.style.package = pkgs.adwaita-qt;

  #gtk.enable = true;
  #gtk.cursorTheme.package = pkgs.capitaine-cursors;
  #gtk.cursorTheme.name    = "capitaine-cursors";
  #gtk.iconTheme.package	  =  pkgs.adwaita-icon-theme;
  #gtk.iconTheme.name 	  = "Adwaita";

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/marius/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
