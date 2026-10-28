{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.user =
    {
      pkgs,
      lib,
      username,
      ...
    }:
    let
      modules = with self.nixosModules; [
        zsh
      ];
    in
    {
      imports = modules;
      users.users.${username} = {
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
