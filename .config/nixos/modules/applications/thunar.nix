{config, pkgs, inputs, ... }:
{
	programs.thunar.enable = true;
	programs.xfconf.enable = true;
	services.gvfs.enable = true;		# Mount, trash, and other functionalities
	services.tumbler.enable = true; 	# Thumbnail support for images

	programs.thunar.plugins = with pkgs.xfce; [
		thunar-archive-plugin
		thunar-volman
		thunar-media-tags-plugin
	];

	environment.systemPackages = [
		pkgs.gvfs
		pkgs.glib
		pkgs.writeTextFile {
		name = "folder-thumbnails";
		      	text = ''
		[Thumbnailer Entry]
		Version=1.0
		Encoding=UTF-8
		Type=X-Thumbnailer
		Name=Folder Thumbnailer
		MimeType=inode/directory;
		Exec=/bin/folder-thumbnailer %s %i %o %u
		      	'';
		      	destination = "/share/thumbnailers/folder.thumbnailer";
		}
		pkgs.writeTextFile {
		name = "";
        	text = ''
		#!/bin/bash

		if [ -f "$2/.folder.jpg" ]; then
			${pkgs.imagemagick}/bin/convert -thumbnail "$1" "$2/.folder.jpg" "$3" 1>/dev/null 2>&1
		elif [ -f "$2/.folder.png" ]; then
			${pkgs.imagemagick}/bin/convert -thumbnail "$1" "$2/.folder.png" "$3" 1>/dev/null 2>&1
		elif [ -f "$2/.folder.svg" ]; then
			${pkgs.inkscape}/bin/inkscape --export-type=png --export-dpi=500 "$2/.folder.svg" --export-filename="$3" 1>/dev/null 2>&1
			${pkgs.imagemagick}/bin/convert -thumbnail "$1" "$3" "$3" 1>/dev/null 2>&1
		else
			rm -f "$HOME/.cache/thumbnails/normal/$(echo -n "$4" | md5sum | cut -d " " -f1).png" || \
			rm -f "$HOME/.thumbnails/normal/$(echo -n "$4" | md5sum | cut -d " " -f1).png" || \
			rm -f "$HOME/.cache/thumbnails/large/$(echo -n "$4" | md5sum | cut -d " " -f1).png" || \
			rm -f "$HOME/.thumbnails/large/$(echo -n "$4" | md5sum | cut -d " " -f1).png"
		fi
        	'';
        	destination = "/bin/folder-thumbnailer";
		}
	];
}
