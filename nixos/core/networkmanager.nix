{ username, ... }:
{
  users.groups.networkmanager.members = ["${username}"];
  networking.networkmanager.enable = true;
}
