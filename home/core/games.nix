{ pkgs, ... }:
{
  imports = [
    ../mangohud/mangohud.nix
  ];

  home.packages =
    (with pkgs; [
      # Minecraft
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
        ];
      })
    ])
    ++
    (with pkgs.unstable; [
      # Switch emulation
      ryujinx

      #Lutris
      lug-helper
      lutris
      cabextract
    ]);

}
