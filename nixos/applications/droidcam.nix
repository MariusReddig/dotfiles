{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    droidcam
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=2 card_label="DroidCam"
  '';
}
