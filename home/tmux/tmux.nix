{ pkgs, username, config, ... }:
{
    programs.tmux = {
    enable = true;
    baseIndex = 1;  # Start window numbering at 1
    keyMode = "vi";  # Use vi-style key bindings
    terminal = "screen-256color";  # Set the terminal type
    plugins =
      (with pkgs.tmuxPlugins; [
        tokyo-night-tmux
        better-mouse-mode
        sensible
        yank
        resurrect
      ]);
    extraConfig = ''
      source-file ~/.config/tmux/custom-tmux.conf
          '';
  };

    home.activation.linkTmuxFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -sfr -T /home/${username}/nix/home/tmux/config/tmux.conf ~/.config/tmux/custom-tmux.conf
  '';
}
