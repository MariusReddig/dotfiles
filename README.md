# NixOS configuration (dendritic)

Built with flake-parts, import-tree and nix-wrapper-modules. Every `.nix` file under `modules/`
is a flake-parts module; paths containing `/_` are skipped (templates, package derivations,
reference hardware configs).

```
modules/
├── parts.nix                  systems + flake-parts imports
├── _empty.nix                 template: NixOS module
├── _home-manager-empty.nix    template: Home Manager module
├── features/                  self-contained features (system and/or user side)
├── home/                      Home Manager modules (flake.homeModules.*) + their dotfiles
├── hosts/                     desktop / laptop: nixosConfigurations + host-only files
├── packages/                  self-packaged software (perSystem packages)
└── system/                    NixOS modules (flake.nixosModules.*)
```

## Rebuild

From inside the repo (needs `--impure`: `/etc/nixos/hardware-configuration.nix` and
`flakeLocation` = `$PWD`):

```
sudo nixos-rebuild switch --impure --flake .
```

The configuration names match the hostnames (`marius-desktop`, `marius-laptop`), so `.` is enough.
After the first switch the `nixos-update` alias does this. Wrapped programs build standalone too:
`nix run .#kitty`, `nix run .#tmux`.

# Checklist:

- [x] System config
  - [x] Core
    - [x] boot
      - [x] bootloader
      - [x] display-manager
      - [x] plymouth
    - [x] locale
    - [x] nix
      - [x] garbage-collection
      - [x] nix-ld
    - [x] audio
      - [x] pipewire
    - [x] networkmanager
      - [x] certificates
      - [x] firewall
    - [x] bluetooth
    - [x] cups
    - [x] drivers
      - [x] upower
      - [x] gpu-drivers
    - [x] gnome-keyring
  - [x] services
    - [x] openssh
    - [x] cups
    - [x] lact
    - [x] avahi
    - [x] mullvad
    - [x] flatpak
    - [x] virt-manager
    - [x] docker

  - [x] home-manager

- [x] Features
  - [x] zsh
  - [x] hyprland (system + user, scripts, hyprlock/hypridle)
  - [x] stylix (system + user)
  - [x] kitty, tmux (nix-wrapper-modules)
  - [x] steam, ubisoft, droidcam, gpu-screen-recorder, thunar, kde-connect, gnome

- [x] User-config
  - [x] desktop
  - [x] laptop
    - [x] battery-monitor
