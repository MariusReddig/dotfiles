{
  self,
  inputs,
  moduleWithSystem,
  ...
}:
let
  username = "marius";
  hostname = "desktop";
in
{
  # drives.nix in this folder adds to the same module
  flake.nixosModules.desktopConfiguration = moduleWithSystem (
    { self', flakeLocation, ... }:
    { pkgs, lib, ... }:
    {
      _module.args = {
        inherit hostname username;
      };
      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "24.11"; # don't remove for compatibility
      networking.hostName = "${username}-${hostname}";

      documentation.nixos.enable = false;

      environment.systemPackages = (
        with pkgs;
        [
          wget
          git
          bash
        ]
      );

      # ============== home-manager =============== #
      home-manager.users.${username} =
        { config, ... }:
        {
          imports = with self.homeModules; [
            packages
            games
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
          ];

          home.stateVersion = "24.11"; # don't remove for compatibility

          home.activation.linkHostDotFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
            ln -sfr -T ${flakeLocation}/modules/home/waybar ~/.config/waybar
          '';
        };
    }
  );
}
