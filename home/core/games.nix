{ pkgs, ... }: {
  home.packages =
    (with pkgs; [

      forge-mtg
      linuxKernel.packages.linux_zen.xpadneo
      # gamescope

      wineWow64Packages.stable
      winetricks
      heroic

      # Minecraft
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
        ];
      })

      #MTG
      # local.mtg-forge
    ])
    ++ (with pkgs.unstable; [
      # Switch emulation
      ryubing

      # archipelago stuff
      archipelago
    ]);

}
