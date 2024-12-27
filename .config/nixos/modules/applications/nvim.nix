{config, pkgs,... }:
{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};

  environment.systemPackages = with pkgs; [
		vimPlugins.fzfWrapper
		cargo
		gccgo14
		cmake
		lazygit
		vim
		bash
		ripgrep
	];

}
