{ self, ... }:
{
  flake.homeModules.games = { pkgs, ... }: {
    home.packages =
      (with pkgs; [

        linuxKernel.packages.linux_zen.xpadneo # controller view

        # Wine stuff
        wineWow64Packages.stable
        winetricks
        umu-launcher

        # Switch emulation
        eden

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
      # Intentionally on unstable: fast-moving, stable lags behind
      ++ (with pkgs.unstable; [

        # archipelago stuff
        archipelago
      ]);

  };
}
