{ ... }: {
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
}
