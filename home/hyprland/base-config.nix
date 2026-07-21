{ config, ... }: {
  imports = [ ./scripts ./ecosystem ];
  home.activation = {
    linkHyprCoreConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfrT ~/nix/home/hyprland/core-config  ~/.config/hypr/core-config
    '';
    linkHyprlandLua = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfrT ~/nix/home/hyprland/hyprland.lua ~/.config/hypr/hyprland.lua
    '';
  };
}
