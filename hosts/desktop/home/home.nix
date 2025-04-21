{ username, config, ... }:
let
  # Module system
  mkModule = path: { imports = [ path ]; };
  homeModule = name: mkModule ../../../home/${name}.nix;
in
{
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };

  zsh.enable = true;

  imports = [
    (homeModule "core/packages")
    (homeModule "core/games")
    (homeModule "zsh")
    (homeModule "nvim/nvim")
    (homeModule "tmux/tmux")
    (homeModule "obs")
    (homeModule "eza")
    (homeModule "firefox/firefox")
    (homeModule "stylix/stylix")
    (homeModule "mangohud/mangohud")
  ];

  home.sessionVariables = {
    XDG_DATA_HOME = "/home/${username}/.local/share/";
    XDG_BACKEND = "x11";
    EDITOR = "nvim";
    VISUAL = "firefox";
    MANPAGER = "nvim +Man!";
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
