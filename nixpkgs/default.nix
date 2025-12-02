{ pkgs ? import <nixpkgs> { } }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    mpc-autofill = callPackage ./mpc-autofill.nix { };
    mtg-forge = callPackage ./forge-mtg/forge-mtg.nix { };
    japanese-aesthetic = callPackage ./sddm-themes/japanese-aesthetic.nix { };
  };
in self
