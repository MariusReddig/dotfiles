{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.droidcam = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      config,
      ...
    }:
    let
      modules = with self.nixosModules; [ ];
    in
    {
      imports = modules;
      environment.systemPackages = with pkgs; [
        droidcam
      ];

      boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
      boot.kernelModules = [ "v4l2loopback" ];
      boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=2 card_label="DroidCam"
      '';
    }
  );
}
