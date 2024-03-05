# My dotfiles for arch-hyprland

my personal repo for all my current dotfiles.
! README is still WIP !

## Requirements

following is required for this configuration

### distro-required
- bluez
- blueman
- thunar
- hyrpland
- swww
- waybar
- swaylock-effects-git
- swayidle
- xdg-desktop-portal
- xdg-desktop-portal-hyprland
- git
- stow
- brightnessctl
- wofi
- kitty
- iio-hyprland
- firewalld

### thememing
- nwg-look
- adwaita-icon-theme
- capitaine-cursors
- ttf-jetbrains-mono-nerd
- yaru-gtk-theme

### applications
- xournalpp
- signal
- spotify
- protonvpn
- bitwarden
- houdoku
- firefox
- tor-browser
- anki
- kdeconnect
- libreoffice-fresh
- loupe / gwenview
- waydroid

### usefull commands
- upower
- iio-hyprland

## Installation

### One-liner for important packages
```
yay -S thunar thunar-volman thunar-media-tags-plugin thunar-archive-plugin hyrpland swww waybar swaylock-effects-git swayidle xdg-desktop-portal xdg-desktop-portal-hyprland git stow wofi kitty networkmanager

```

### Networkmanager
```
sudo pacman -S networkmanager
systemctl enable NetworkManager.service --now
```

### Thememing
```
yay -S nwg-look adwaita-icon-theme capitaine-cursors ttf-jetbrains-mono-nerd yaru-gtk-theme
```
### Yay
one liner:
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

###

## TODO
[ ] complete Requirements
[ ] custom / multiple Themes
[ ] (propper)multi-monitor support
