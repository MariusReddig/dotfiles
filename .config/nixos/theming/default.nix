{ lib, config, ... }:
let
  cfg = config.theming;
in
{
  imports = [
    ./themes/hyprland-oni.nix
  ];

  options.theming = {
    enable = lib.mkEnableOption "enable theming module";
    theme = lib.mkOption {
      default = "hyprland-oni";
      description = "the wished theme";
    };
  };

  config = {
    hypr-oni = lib.optionals (cfg.theme == "hyprland-oni") {
      enable = true;
    };
  };
}
