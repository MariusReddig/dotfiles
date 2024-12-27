{config, pkgs,... }:
{
	programs.thunar.enable = true;
	programs.xfconf.enable = true;
	services.gvfs.enable = true;		# Mount, trash, and other functionalities
	services.tumbler.enable = true; # Thumbnail support for images

	programs.thunar.plugins = with pkgs.xfce; [
		thunar-archive-plugin
		thunar-volman
		thunar-media-tags-plugin
	];

	environment.systemPackages = with pkgs; [
		gvfs
	];
}
