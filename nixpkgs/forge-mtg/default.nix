{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./forge-mtg.nix {}
