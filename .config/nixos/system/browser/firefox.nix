{config, pkgs, lib, ... }:
{
	options = {
		firefox.enable = lib.mkEnableOption "enable firefox module";
	};

	config = lib.mkIf config.firefox.enable {
		programs.firefox.enable = true;
	};
}
