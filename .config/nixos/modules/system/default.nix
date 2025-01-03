{ pkgs, lib,...}: {
	imports = [
		./drivers
		./bootloader.nix
		./fonts.nix
		./greeter.nix
		./localisation.nix
		./networkmanager.nix
		./nix.nix
		./openssh.nix
		./pipewire.nix
		./bluetooth.nix
	];
}
