{ pkgs, ... }: {
  services.flatpak.enable = true;
  services.flatpak.packages = [
    {
      appId = "com.usebottles.bottles";
      origin = "flathub";
    }
    {
      appId = "io.github.n00byking.sm64ap-launcher";
      bundle = "file:///home/marius/nix/nixos/applications/flatpak/sm64ap-launcher.flatpak";
    }
  ];
}
