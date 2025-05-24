{ ... }:
{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "robbyrussell";
    settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./config.omp.json ));
  };
}
