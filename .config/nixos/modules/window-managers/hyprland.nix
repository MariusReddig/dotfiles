{ lib, config, pkgs, inputs, ... }:
{
	config = {
		programs.hyprland = {
		  enable = true;
			xwayland.enable = true;
		  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
		  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
		};

		environment.sessionVariables.NIXOS_OZONE_WL = "1";
		environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

		environment.systemPackages = with pkgs; [
		  hyprpicker
		  hyprlock
		  hypridle
			hyprland-qtutils
		  kitty
		  hyprpolkitagent
		  xdg-desktop-portal-hyprland
		  hyprland-protocols
			inputs.swww.packages.${pkgs.system}.swww
		];
	};
}
