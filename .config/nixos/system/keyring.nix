{ lib, config, pkgs, ... }:
{
  options.keyring = {
    enable = lib.mkEnableOption "enable gnome keyring";
  };

  config = lib.mkIf config.keyring.enable {
    environment.systemPackages = with pkgs; [
      libsecret
      gcr
      gnome-keyring
      seahorse
    ];

    # Create the keyring directory at runtime (temporary)
    # systemd.tmpfiles.rules = [
    #   "d /run/user/1000/keyring/ 0700 ${config.users.users.marius.name} ${config.users.users.marius.name} - -"
    # ];

    # Enable GNOME Keyring in PAM for login sessions

    # Start GNOME Keyring daemon automatically
    # systemd.user.services.gnome-keyring = {
    #   enable = true;
    #   description = "Gnome Keyring Daemon";
    #   serviceConfig = {
    #     Type = "forking";
    #     ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets,ssh,pkcs11";
    #     Environment = [
    #       "GNOME_KEYRING_CONTROL=/run/user/%U/keyring"
    #       "SSH_AUTH_SOCK=/run/user/%U/keyring/ssh"
    #     ];
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #   };
    #   wantedBy = [ "default.target" ];
    # };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
    programs.seahorse.enable = true;

    # Optional: Ensure the keyring directory exists with correct permissions
    # systemd.tmpfiles.rules = [
    #   "d /run/user/%U/keyring 0700 %u %u - -"
    # ];
  };
}
