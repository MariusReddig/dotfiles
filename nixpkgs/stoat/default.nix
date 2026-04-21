{ pkgs ? import <nixpkgs> { } }:

pkgs.callPackage ./stoat.nix { }
