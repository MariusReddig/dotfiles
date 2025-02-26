{ config, ... }:
let
  user = config.main-user.userName;
in
{
  systemd.tmpfiles.rules = [
    "d /run/media/${user}/nvme0n1p3 0755 ${user} users -"
    "d /run/media/${user}/sdb1 0755 ${user} users -"
    "d /run/media/${user}/sda1 0755 ${user} users -"
  ];

  fileSystems = {
    "/run/media/${user}/nvme0n1p3" = {
      device = "/dev/nvme0n1p3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/run/media/${user}/sdb1" = {
      device = "/dev/sdb1";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/run/media/${user}/sda1" = {
      device = "/dev/sda1";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };
  };
}
