# User basics every host shares. Imported automatically by nixosModules.home-manager.
{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.base = moduleWithSystem (
    { flakeLocation, ... }:
    {
      config,
      username,
      hostname,
      ...
    }:
    {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";

        sessionVariables = {
          XDG_DATA_HOME = "/home/${username}/.local/share/";
          XDG_BACKEND = "x11";
          EDITOR = "nvim";
          VISUAL = "firefox";
          MANPAGER = "nvim +Man!";
        };

        # Per-host Thunar config and .editorconfig
        activation.linkDotFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
          ln -sfr -T ${flakeLocation}/modules/hosts/${hostname}/thunar        ~/.config/Thunar
          ln -sfr -T ${flakeLocation}/modules/hosts/${hostname}/.editorconfig ~/.editorconfig
        '';
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    }
  );
}
