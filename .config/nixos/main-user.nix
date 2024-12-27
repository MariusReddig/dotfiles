{ lib, config, pkgs, ... }:

let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";
    userName = lib.mkOption {
      default = "main-user";
      description = ''username'';
    };
    hostName = lib.mkOption {
      default = ''${cfg.userName}-nixos'';
      description = ''hostname'';
    };
	};

  config = lib.mkIf cfg.enable {

		users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "main user";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
    };


    networking.hostName = ''${cfg.hostName}'';
  };
}
