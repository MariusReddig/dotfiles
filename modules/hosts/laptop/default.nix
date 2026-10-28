{
  self,
  inputs,
  ...
}:
{
  # Name = networking.hostName, so `nixos-rebuild switch --flake .` picks it automatically
  flake.nixosConfigurations.marius-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      laptopConfiguration
      core
      pipewire
      amd
      upower
      networking
      kde-connect
      nix-ld
      gnome-keyring
      plymouth
      battery-monitor
      thunar
      steam
      hyprland
      docker
      virt-manager
      gpu-screen-recorder
      flatpak
      stylix
      home-manager
    ];
  };
}
