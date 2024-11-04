# My dotfiles for arch-hyprland

my personal repo for all my current dotfiles.  
! README is still WIP !

## Requirements

following is required for this configuration

### distro-required
- bluez
- bluez-utils
- blueman
- thunar
	- thunar-archive-plugin
	- thunar-media-tags-plugin
	- thunar-volman
- dunst
- polkit-gnome
- hyrpland
- swww
- waybar
- hyprlock
- hypridle
- xdg-desktop-portal
- xdg-desktop-portal-hyprland
- git
- stow
- brightnessctl
- wofi
- kitty
- firewalld
- cronie
- network-manager-applet-git
	- networkmanager-openvpn
- zip
- zsh

One-liner:
```
yay -S bluez blueman thunar dunst polkit-gnome hyprland swww waybar hyprlock swww waybar hyprlock hypridle xdg-desktop-portal xdg-desktop-portal-hyprland git stow brightnessctl wofi kitty firewalld conie zip zsh networkmanager-openvpn network-manager-applet-git thunar-media-tags-plugin thunar-volman thunar-archive-plugin
```

### thememing

- nwg-look
- adwaita-icon-theme
- capitaine-cursors
- ttf-jetbrains-mono-nerd
- yaru-gtk-theme
- noto-fonts-emoji
- noto-fonts-extra

One-liner:
```
yay -S nwg-look adwaita-icon-theme capitaine-cursors ttf-jetbrains-mono-nerd yaru-gtk-theme noto-fonts-emoji noto-fonts-extra
```

### applications

- xournalpp
- signal-desktop
- spotify
- mullvad-vpn-beta
- bitwarden
- zen-browser
- firefox
- tor-browser
- anki
- kdeconnect
- libreoffice-fresh
- loupe
- gwenview
- cpupower-gui
- vesktop
- thunderbird
- steam
- sddm-conf-git
- qalculate-qt

One-liner:
```
yay -S xournalpp signal-desktop spotify mullvad-vpn-beta bitwarden firefox zen-browser anki kdeconnect libreoffice-fresh loupe gwenview cpupower-gui vesktop thunderbird sddm-conf-git qalculate-qt
```
## configuration:

### Networkmanager
```
sudo pacman -S networkmanager
systemctl enable NetworkManager.service --now
```
### Bluetooth
```
sudo pacman -S bluez
systemctl enable bluez
```

### Yay

One-liner:
```
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### oh-my-zsh
```
pacman -S curl zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### batsignal

open the crontab:
```
crontab -e 
```

insert:
```
*/5 * * * * /bin/bash /home/marius/.config/hypr/scripts/batsignal
```
## Installation
```
git clone git@github.com:MariusReddig/dotfiles.git
cd dotfiles
stow -vRt ~ .

```
