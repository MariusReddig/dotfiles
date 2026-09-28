{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.name = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    let
      modules = with self.nixosModules; [ ];
    in
    {
      imports = modules;
      programs.hyprland = {
        enable = true;
        package = pkgs.hyprland;
        xwayland.enable = true;
      };

      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
        systemPackages = with pkgs; [
          hyprlock
          hypridle
          hyprpolkitagent
          hyprland-protocols
          hyprshutdown
          hyprpicker
          hyprpwcenter
          waybar
        ];
      };
    }
  );
}
