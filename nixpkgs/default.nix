{ pkgs ? import <nixpkgs> { } }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = {
    mpc-autofill = callPackage ./mpc-autofill.nix { };
    forge-mtg = callPackage ./forge-mtg/forge-mtg.nix { };
    japanese-aesthetic = callPackage ./sddm-themes/japanese-aesthetic.nix { };
    stoat = callPackage ./stoat/stoat.nix { };
  };
in self
