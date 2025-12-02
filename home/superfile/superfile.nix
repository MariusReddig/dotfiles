{ config, pkgs, ... }: {
  home.packages = (with pkgs; [ unstable.superfile zoxide exiftool ]);
  programs.superfile = {
    enable = true;
    package = pkgs.unstable.superfile;
    metadataPackage = pkgs.exiftool;
    zoxidePackage = pkgs.zoxide;
    settings = {
      open_with = {
        ".png" = "qview";
        ".jpg" = "qview";
        ".jpeg" = "qview";
        ".pdf" = "zathura";
        ".mp4" = "vlc";
      };
    };
  };

  # home.activation.linkSuperfileConfig =
  #   config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #     ln -sfr -T ~/nix/home/superfile/config.toml ~/.config/superfile/config.toml
  #   '';
}
