{
  self,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.gpu-screen-recorder = moduleWithSystem (
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    let
      modules = with self.nixosModules; [ ];
    in
    {
      imports = modules;
      programs.gpu-screen-recorder.enable = true;
      environment.systemPackages = (with pkgs; [ gpu-screen-recorder-gtk ]);
    }
  );
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.hello = pkgs.hello;
    };
}
