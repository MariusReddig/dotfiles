{config, pkgs,... }:
{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};

	home.packages = with pkgs; {
		vimPlugins.fzfWrapper
		cargo
		gccgo14
		cmake
		lazyvim
		vim
		bash
		ripgrep
	};

}
