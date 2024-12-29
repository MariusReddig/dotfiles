{ config, pkgs, inputs, ... }:
{
  home = {
		packages = with pkgs; [
			waybar
			swww
			capitaine-cursors
			wofi
			dunst
			morewaita-icon-theme
			gnome-themes-extra
			libnotify
		];

		pointerCursor = {
			gtk.enable = true;
			x11.enable = true;
			name = "capitaine-cursors";
			size = 40;
			package = pkgs.capitaine-cursors;
		};
	
		sessionVariables = {
		  EDITOR = "nvim";
		};
	};

	gtk = {
		enable = true;
		
		theme = {
			name = "Adwaita-dark";
			package = pkgs.gnome-themes-extra;
    };
		
		iconTheme = {
			name = "MoreWaita";
			package = pkgs.morewaita-icon-theme;
		};

		gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
				color-scheme = "prefer-dark"
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
				color-scheme = "prefer-dark"
      '';
    };
	};

	qt = {
    enable = true;
		platformTheme = "qtct";
    style.name = "Adwaita-dark";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
