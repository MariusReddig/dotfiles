# tmux wrapped with nix-wrapper-modules (`nix run .#tmux`). The hand-written part stays
# live-editable in ./config/tmux.conf and is sourced at the end.
{
  self,
  inputs,
  moduleWithSystem,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.tmux = inputs.wrappers.wrappers.tmux.wrap {
        inherit pkgs;
        baseIndex = 1; # Start window numbering at 1
        modeKeys = "vi"; # Use vi-style key bindings
        statusKeys = "vi";
        terminal = "screen-256color";
        # Keep the old Home Manager defaults where the wrapper's differ
        mouse = false;
        escapeTime = 500;
        clock24 = false;
        disableConfirmationPrompt = false;

        plugins = with pkgs.tmuxPlugins; [
          tokyo-night-tmux
          better-mouse-mode
          sensible
          yank
          resurrect
        ];
        configAfter = ''
          source-file -q ~/.config/tmux/custom-tmux.conf
        '';
      };
    };

  flake.homeModules.tmux = moduleWithSystem (
    { self', flakeLocation, ... }:
    { config, ... }:
    {
      home.packages = [ self'.packages.tmux ];

      home.activation.linkTmuxFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ~/.config/tmux
        ln -sfr -T ${flakeLocation}/modules/features/tmux/config/tmux.conf ~/.config/tmux/custom-tmux.conf
      '';
    }
  );
}
