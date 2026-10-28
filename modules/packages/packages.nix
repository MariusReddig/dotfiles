# Self-packaged software as flake packages: `nix build .#stoat`, `self'.packages.stoat` in modules.
# The derivations live in ./_pkgs ("_" keeps import-tree from loading them as flake modules).
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        stoat = pkgs.callPackage ./_pkgs/stoat/stoat.nix { };
        japanese-aesthetic = pkgs.callPackage ./_pkgs/sddm-themes/japanese-aesthetic.nix { };
        forge-mtg = pkgs.callPackage ./_pkgs/forge-mtg/forge-mtg.nix { };
        mpc-autofill = pkgs.callPackage ./_pkgs/mpc-autofill.nix { };
      };
    };
}
