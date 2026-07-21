{ config, pkgs, ... }:

let
  # Common search engines
  nixSearchEngines =
    let
      nixIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    in
    {
      "NixOS Packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages?query={searchTerms}";
          }
        ];
        icon = nixIcon;
        definedAliases = [ "@np" ];
      };
      "NUR Packages" = {
        urls = [
          {
            template = "https://nur.nix-community.org/repos?query={searchTerms}";
          }
        ];
        icon = nixIcon;
        definedAliases = [
          "@nur"
          "@nr"
        ];
      };
      "NixOS Options" = {
        urls = [
          {
            template = "https://search.nixos.org/options?query={searchTerms}";
          }
        ];
        icon = nixIcon;
        definedAliases = [ "@no" ];
      };
      "Home-manager Options" = {
        urls = [
          {
            template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=release-26.05";
          }
        ];
        icon = nixIcon;
        definedAliases = [ "@ho" ];
      };
    };

  # duckduckgo engine
  duckduckgo = {
    "ddg" = {
      urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
      definedAliases = [ "@d" ];
    };
  };
in
{
  config = {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          extensions.force = true;
          search = {
            force = true;
            default = "ddg";
            order = [
              "ddg"
              "NixOS Packages"
              "NUR Packages"
              "NixOS Options"
            ];
            engines = nixSearchEngines // duckduckgo;
          };
        };

        dark = {
          id = 1;
          name = "dark";
          isDefault = false;
          containersForce = true;
          extensions.force = true;
          containers = {
            r-1 = {
              id = 1;
              color = "red";
              icon = "circle";
            };
            r-2 = {
              id = 2;
              color = "blue";
              icon = "circle";
            };
            p = {
              id = 3;
              color = "orange";
              icon = "circle";
            };
            j = {
              id = 4;
              color = "turquoise";
              icon = "circle";
            };
          };
          search = {
            force = true;
            default = "ddg";
            engines = duckduckgo;
          };
        };
      };
    };

    stylix.targets.firefox = {
      enable = true;
      colorTheme.enable = true;
      profileNames = [
        "default"
        "dark"
      ];
    };
  };
}
