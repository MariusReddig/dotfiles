{
  self,
  inputs,
  moduleWithSystem,
  ...
}:
let
  username = "marius";
  hostname = "laptop";
in
{
  flake.nixosModules.laptopConfiguration = moduleWithSystem (
    { self', ... }:
    { pkgs, lib, ... }:
    {
      _module.args = {
        inherit hostname username;
      };
      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "24.11"; # Don't remove for compatibility
      networking.hostName = "${username}-${hostname}";
      networking.networkmanager.wifi.powersave = true;
      documentation.nixos.enable = false;

      environment.systemPackages = (
        with pkgs;
        [
          wget
          git
          bash
          firefox
        ]
      );

      # ============== plymouth theme =============== #
      stylix.targets.plymouth.enable = false;
      boot.plymouth = {
        theme = "thinkdar";
        themePackages = [ self'.packages.thinkdar-plymouth-theme ];
      };

      # ============== home-manager =============== #
      home-manager.users.${username} =
        { ... }:
        {
          imports = with self.homeModules; [
            packages
            zsh
            nvim
            tmux
            obs
            eza
            zathura
            firefox
            fuzzel
            kitty
            pferd
            dunst
            zoxide
            fzf
            stylix
            oh-my-posh
            superfile
            balatro
            hyprland
            quickshell
            laptop
          ];

          home.stateVersion = "24.11"; # Don't remove for compatibility
        };
    }
  );
}
