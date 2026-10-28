# Boot splash. Without a theme set, stylix themes it.
# For one of the thinkpad themes set e.g. in the host:
#   stylix.targets.plymouth.enable = false;
#   boot.plymouth.theme = "thinkdar";
#   boot.plymouth.themePackages = [ self'.packages.thinkdar-plymouth-theme ];
{ self, inputs, ... }:
{
  flake.nixosModules.plymouth = {
    boot.plymouth.enable = true;
  };
}
