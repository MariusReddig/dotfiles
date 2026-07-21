{ pkgs, ... }: {
  home.packages =
    (with pkgs; [

      # controller test
      jstest-gtk

      forge-mtg
      linuxKernel.packages.linux_zen.xpadneo
      lutris
      # gamescope

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
      # freetype
    ]);

}
