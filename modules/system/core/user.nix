{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.user-marius =
    {
      pkgs,
      lib,
      ...
    }:
    let
      modules = with self.nixosModules; [
        zsh
      ];
    in
    {
      imports = modules;
      users.users.marius = {
        isNormalUser = true;
        initialPassword = "qwer";
        shell = pkgs.zsh;
        description = "user01";
        extraGroups = [
          "root"
          "wheel"
          "networkmanager"
        ];
      };
    };
}
