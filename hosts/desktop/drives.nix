{ config, username, ... }:
{
  systemd.tmpfiles.rules = [
    "d /run/media/${username}/sdb1 0755 ${username} users -"
    "d /run/media/${username}/sda1 0755 ${username} users -"
  ];

  fileSystems = {
    "/run/media/${username}/sdb1" = {
      device = "/dev/disk/by-uuid/735bf511-15af-48e4-9b15-7496f24a4f44";
      fsType = "ext4";
      options = [ "defaults" "noatime" "discard" "nofail" ];
    };

    "/run/media/${username}/sda1" = {
      device = "/dev/disk/by-uuid/afa61223-0142-4f76-b707-a14d0f4b55db";
      fsType = "ext4";
      options = [ "defaults" "noatime" "discard" "nofail" ];
    };
  };
}
