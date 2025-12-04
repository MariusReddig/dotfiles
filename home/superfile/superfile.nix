{ pkgs, inputs, system, config, ... }: {
  home.packages = (with pkgs; [ zoxide exiftool ]);
  programs.superfile = {
    enable = true;
    package = inputs.superfile.packages.${system}.default;
    metadataPackage = pkgs.exiftool;
    zoxidePackage = pkgs.zoxide;
    # settings = builtins.fromTOML (builtins.readFile ./config.toml);
  };

  home.activation.linkSuperfileConfig =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfr -T ~/nix/home/superfile/config.toml ~/.config/superfile/config.toml
    '';
}
