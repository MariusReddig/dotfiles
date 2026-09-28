{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.mariu-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      laptopConfiguration
      core
      pipewire
      amd
      upower
      networking
      nix-ld
      thunar
      steam
      hyprland
      docker
    ];
  };
}
