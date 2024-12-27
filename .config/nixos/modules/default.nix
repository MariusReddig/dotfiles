{ config, pkgs, inputs,...}:{
	imports = [
		./applications
		./system
		./window-managers
	];
}
