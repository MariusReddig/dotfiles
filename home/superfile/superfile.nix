{ pkgs, inputs, config, ... }: {
  programs.superfile = {
    enable = true;
    # package = inputs.superfile.packages.${pkgs.stdenv.hostPlatform.system}.default;
    metadataPackage = pkgs.unstable.exiftool;
    zoxidePackage = pkgs.unstable.zoxide;
    # settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };

  home.activation.linkSuperfileConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfr -T ~/nix/home/superfile/config.toml ~/.config/superfile/config.toml
    '';
}
