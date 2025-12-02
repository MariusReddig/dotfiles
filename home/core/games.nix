{ pkgs, ... }: {
  imports = [ ../mangohud/mangohud.nix ];

  home.packages = (with pkgs; [
    umu-launcher
    # protonup-qt
    # controller test
    jstest-gtk
    linuxKernel.packages.linux_zen.xpadneo

    protontricks
    # Minecraft
    (prismlauncher.override { jdks = [ jdk8 jdk17 jdk21 ]; })

    #MTG
    # local.mtg-forge
  ]) ++ (with pkgs.unstable; [
    # Switch emulation
    ryubing

    #Lutris
    # lug-helper
    lutris
    cabextract
  ]);

}
