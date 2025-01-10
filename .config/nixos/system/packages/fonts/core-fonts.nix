{ config, pkgs, lib, ... }:
{
  options.fonts = {
    enable = lib.mkEnableOption "enable core fonts";
  };

  config = lib.mkIf config.fonts.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      corefonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      ipafont
    ];
  };
}
