{ lib, config, pkgs, ... }:

let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";
    userName = lib.mkOption {
      default = "mainuser";
      description = ''username'';
    };
    hostName = lib.mkOption {
      default = ''${cfg.userName}-pc'';
      description = ''hostname'';
    };
  };

  config = lib.mkIf cfg.enable {
	
    programs.zsh.enable = true;
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = "main user";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
    };
    networking.hostName = ''${cfg.hostName}'';
    
  };
}
