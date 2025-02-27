{ config, pkgs, pkgs-unstable, lib, ... }:
{
  options.fonts = {
    enable = lib.mkEnableOption "enable core fonts";
  };

  config = lib.mkIf config.fonts.enable {
    fonts.packages =
      (with pkgs; [
        corefonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        noto-fonts-extra
        ipafont
      ])
      ++
      (with pkgs-unstable; [
        nerd-fonts.jetbrains-mono
      ]);
  };
}
