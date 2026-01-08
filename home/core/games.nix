{ pkgs, ... }: {
  imports = [ ../mangohud/mangohud.nix ];

  home.packages = (with pkgs; [

    # controller test
    jstest-gtk

    forge-mtg
    linuxKernel.packages.linux_zen.xpadneo

    # Minecraft
    (prismlauncher.override { jdks = [ jdk8 jdk17 jdk21 ]; })

    #MTG
    # local.mtg-forge
  ]) ++ (with pkgs.unstable; [
    # Switch emulation
    ryubing

    # archipelago stuff
    archipelago
    freetype
    (wine.override { wineBuild = "wineWow"; })
    protonup-ng
    protontricks

    #Lutris
    # lug-helper
    lutris
    cabextract
  ]);

}
