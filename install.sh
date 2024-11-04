#!/bin/bash
# simple intstall-script for my dotfiles

# install this repo
sudo pacman -S stow
stow -vRt ~ .

# install yay
sudo pacman -S --needed base-devel git
sh -c "clone https://aur.archlinux.org/yay.git; cd yay; makepkg -si "
rm -r yay

# install hardware and security fixes
yay -S amd-ucode

# install filesystem-utils
yay -S e2fsprogs dosfstools ntfs-3g fuse3 mdadm lvm2

# install command-utils
yay -S man-db man-pages textinfo

#install hyprland
yay -S hyprland-git

#install the networkmanager
yay -S networkmanager networkmanager-applet-git networkmanager-openvpn
systemctl enable -n NetworkManager.service

#enable bluetooth
yay -S bluez bluez-utils blueman
systemctl enable -n bluetooth.service

# install cups
yay -S cups cups-pdf
systemctl enable -n cups.service

yay -S sddm
sudo cp -r ./sugar-candy /usr/share/sddm/themes/
# install reqquired packages
yay -S thunar thunar-volman thunar-media-tags-plugin thunar-archive-plugin dunst polkit-gnome swww waybar hyprlock hypridle xdg-deskop-portal xdg-desktop-portal-hyprland brightnessctl wofi cronie zip

#install themeing packages
yay -S nwg-look adwaita-icon-theme capitaine-cursors ttf-jetbrains-mono-nerd yaru-gtk-theme yaru-sound-theme noto-fonts-emoji noto-fonts-extra

#install other stuff
yay -S xournalpp signal-desktop spotify mullvad-vpn-beta bitwarden zen-browser firefox tor-browser anki kdeconnect libreoffice-fresh loupe gwenview cpupower-gui vesktop thunderbird steam sddm-conf-git qualculate-qt

# enter batsignal into crontab
(
	crontab -l 2>/dev/null
	echo "*/5 * * * * /bin/bash /home/marius/.config/hypr/scripts/batsignal
"
) | crontab -

# install oh-my-zsh
yay -S curl zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh
