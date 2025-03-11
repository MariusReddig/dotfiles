{ config, username, ... }:
{
  systemd.tmpfiles.rules = [
    "d /run/media/${username}/nvme0n1p3 0755 ${username} users -"
    "d /run/media/${username}/sdb1 0755 ${username} users -"
    "d /run/media/${username}/sda1 0755 ${username} users -"
  ];

  fileSystems = {
    "/run/media/${username}/nvme0n1p3" = {
      device = "/dev/nvme0n1p3";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/run/media/${username}/sdb1" = {
      device = "/dev/sdb1";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/run/media/${username}/sda1" = {
      device = "/dev/sda1";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };
  };
}
