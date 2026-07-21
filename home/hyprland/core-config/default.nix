{ config, pkgs, ... }: {
  home = {
    file.".config/hypr/source-files/import-sources.conf".text = ''
      source = ~/.config/hypr/source-files/autostart.conf
      source = ~/.config/hypr/source-files/decoration.conf
      source = ~/.config/hypr/source-files/device-input.conf
    '';

    activation.linkHyprSourceFiles =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfrT ~/nix/home/hyprland/source-files/autostart.conf  ~/.config/hypr/source-files/autostart.conf
        ln -sfrT ~/nix/home/hyprland/source-files/decoration.conf ~/.config/hypr/source-files/decoration.conf
        ln -sfrT ~/nix/home/hyprland/source-files/device-input.conf ~/.config/hypr/source-files/device-input.conf
      '';
  };
}
