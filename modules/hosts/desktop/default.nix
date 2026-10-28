{
  self,
  inputs,
  ...
}:
{
  # Name = networking.hostName, so `nixos-rebuild switch --flake .` picks it automatically
  flake.nixosConfigurations.marius-desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      desktopConfiguration
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
      ubisoft
      droidcam
      hyprland
      gnome
      docker
      virt-manager
      gpu-screen-recorder
      flatpak
      stylix
      home-manager
    ];
  };
}
