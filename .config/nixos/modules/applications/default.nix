{ pkgs, lib,...}: {
	imports = [
		./nvim.nix
		./zsh.nix
		./thunar.nix
	];
}
