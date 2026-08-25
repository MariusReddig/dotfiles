{
  config,
  inputs,
  pkgs,
  username,
  ...
}:
{
  home.packages = (with pkgs; [ quickshell ]);

  home.file = {
    ".config/quickshell".source =
      config.lib.file.mkOutOfStoreSymlink "/home/${config.home.username}/nix/home/quickshell/config";
  };
}
