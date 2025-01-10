{config, pkgs, lib, ... }:
{
	options = {
		mullvad.enable = lib.mkEnableOption "enable mullvad-vpn module";
	};

	config = lib.mkIf config.mullvad.enable {
		home.packages = with pkgs; [
		mullvad-vpn
		];
	};
}
