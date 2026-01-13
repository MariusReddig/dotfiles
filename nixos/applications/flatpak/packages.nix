{ pkgs, ... }: {

  # Enable Flatpak for user
  services.flatpak.enable = true;

  # Declarative Flatpak packages in Home Manager
  services.flatpak.packages = [
    # Stremio (beta version)
    {
      appId = "com.stremio.Stremio";
      origin = "flathub";
      branch = "beta";
    }

    # Other apps
    "org.mozilla.firefox"
    "com.visualstudio.code"
    "com.discordapp.Discord"
    "com.spotify.Client"
  ];

  # Configure XDG portals (important for Hyprland)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Environment variables for Flatpak
  home.sessionVariables = {
    # For .desktop files to appear in launchers
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
  };

  # Optional: Add Flatpak bin to PATH
  home.sessionPath = [ "$HOME/.local/share/flatpak/exports/bin" ];
}
