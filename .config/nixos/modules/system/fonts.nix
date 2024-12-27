{config, pkgs, inputs, ... }:{
  fonts.packages = with pkgs; [ 
		nerd-fonts.jetbrains-mono
		corefonts
    noto-fonts
		noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts-extra
		ipafont
  ];
}
