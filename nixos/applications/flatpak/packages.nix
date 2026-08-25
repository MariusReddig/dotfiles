{ pkgs, ... }: {
  services.flatpak.enable = true;
  services.flatpak.packages = [
    {
      appId = "com.stremio.Stremio";
      origin = "flathub";
    }
    {
      appId = "io.github.Soundux";
      origin = "flathub";
    }
  ];
}
