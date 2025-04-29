{ lib, pkgs, ... }:
{
  stylix.targets.kitty.enable = false;
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font.package = pkgs.unstable.nerd-fonts.jetbrains-mono;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    extraConfig = lib.mkDefault ''
      # Kitty theme file - tokyo-night theme
      ${builtins.readFile ./theme.conf}

      # Kitty config
      enable_audio_bell no
    '';
  };
}
