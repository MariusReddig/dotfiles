{
  username,
  config,
  inputs,
  ...
}:
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
    (homeModule "zsh")
    (homeModule "nvim/nvim")
    (homeModule "tmux/tmux")
    (homeModule "obs")
    (homeModule "eza")
    (homeModule "zanthura")
    (homeModule "firefox/firefox")
    (homeModule "fuzzel/fuzzel")
    (homeModule "kitty/kitty")
    (homeModule "pferd/pferd")
    # (homeModule "dunst/dunst")
    (homeModule "zoxide/zoxide")
    (homeModule "fzf/fzf")
    (homeModule "stylix/stylix")
    (homeModule "oh-my-posh/oh-my-posh")
    (homeModule "superfile/superfile")
    (homeModule "balatro/balatro")
    # (homeModule "caelestia/caelestia")

    (homeModule "core/games")

    (homeModule "hyprland/base-config")
    ./hyprland/hyprland.nix

  ];

  home.sessionVariables = {
    XDG_DATA_HOME = "/home/${username}/.local/share/";
    XDG_BACKEND = "x11";
    EDITOR = "nvim";
    VISUAL = "firefox";
    MANPAGER = "nvim +Man!";
  };

  home.activation.linkDotFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T /home/${username}/nix/hosts/desktop/home/thunar        ~/.config/Thunar
    ln -sfr -T /home/${username}/nix/hosts/desktop/home/.editorconfig ~/.editorconfig
    ln -sfr -T /home/${username}/nix/hosts/desktop/home/waybar        ~/.config/waybar
  '';

  programs.fuzzel.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.wine-sni-bridge.enable = true;
}
