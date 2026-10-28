# pillbar (quickshell). ./config is linked to ~/.config/quickshell itself (start with plain
# `quickshell`, no `-c`), ./hyprland.lua to ~/.config/hypr/quickshell.lua (autostart + keybinds,
# loaded by hyprland.lua when present).
{
  moduleWithSystem,
  ...
}:
{
  flake.homeModules.quickshell = moduleWithSystem (
    { self', flakeLocation, ... }:
    { pkgs, config, ... }:
    let
      link = "${self'.packages.link-config}/bin/link-config";
    in
    {
      home.packages = with pkgs; [
        quickshell
        nerd-fonts.symbols-only # pillbar state icons
      ];

      home.activation.linkQuickshellConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ${link} ${flakeLocation}/modules/home/quickshell/config       ~/.config/quickshell
        ${link} ${flakeLocation}/modules/home/quickshell/hyprland.lua ~/.config/hypr/quickshell.lua
      '';
    }
  );
}
