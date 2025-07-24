{ username, pkgs, ... }:
{
   environment.systemPackages = with pkgs; [
    virt-manager
    # libvirt
    # OVMF
  ];
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["${username}"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
