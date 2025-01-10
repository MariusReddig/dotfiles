{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.python312Packages.pip
    pkgs.clang
    pkgs.jdk21
    pkgs.jdk8
  ];
}
