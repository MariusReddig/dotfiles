# This is my current NIXOS-configuration

## Installation:
1. clone repo
```
cd /home/${USER} && git clone https://github.com/MariusReddig/dotfiles.git
```
2. reconfigure host to your liking
3. rebuild
```
sudo nixos-rebuild switch --flake /home/${USER}/nix#desktop
```
or
```
sudo nixos-rebuild switch --flake /home/${USER}/nix#laptop
```
