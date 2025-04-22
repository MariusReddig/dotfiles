{ pkgs, pkgs-unstable, mic92-nur, ... }:

let
  # Common settings for all profiles
  commonSettings = {
    # Privacy & Security
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "privacy.resistFingerprinting" = true;
    "privacy.donottrackheader.enabled" = true;
    "browser.send_pings" = false;
    "network.http.referer.trimmingPolicy" = 2;
    "network.http.referer.XOriginPolicy" = 2;

    # Performance
    "browser.cache.disk.enable" = false;
    "gfx.webrender.all" = true;

    # UI/UX
    "browser.aboutConfig.showWarning" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "mousewheel.default.delta_multiplier_y" = 100;

    "browser.urlbar.update2" = true;

    # Dark mode (applies to all profiles)
    "ui.systemUsesDarkTheme" = 1;
    "browser.in-content.dark-mode" = true;

    # Theme
    "svg.context-properties.content.enabled" = true;
    "layers.acceleration.force-enabled" = true;
  };

  # Common extensions for all profiles
  commonExtensions = (with pkgs-unstable.nur.repos.rycee.firefox-addons; [
    # Privacy
    ublock-origin
    privacy-badger
    clearurls
    duckduckgo-privacy-essentials

    # Productivity
    bitwarden
    tridactyl
    sidebery
    simple-tab-groups

    # Media
    sponsorblock
  ]);

  # Common policies for all profiles
  commonPolicies = {
    DisableTelemetry = true;
    DisablePocket = true;
    ExtensionSettings = {
      # Chameleon
      "jid1-BoFifL9Vbdl2zQ@jetpack" = {
        installation_mode = "normal";
        default_area = "navbar";
      };
      # DuckDuckGo Privacy Essentials
      "jid1-ZAdIEUB7XOzOJw@jetpack" = {
        installation_mode = "normal";
        default_area = "navbar";
      };
      # nightTab
      "{12a9d7c9-8b6a-4a08-9e29-8d4b6c6e9d9a}" = {
        installation_mode = "normal";
        default_area = "navbar";
      };
    };
  };

  # Common search engines
  nixSearchEngines = let
    nixIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  in {
    "NixOS Packages" = {
      urls = [{ template = "https://search.nixos.org/packages?query={searchTerms}"; }];
      icon = nixIcon;
      definedAliases = [ "@np" ];
    };
    "NUR Packages" = {
      urls = [{ template = "https://nur.nix-community.org/repos?query={searchTerms}"; }];
      icon = nixIcon;
      definedAliases = [ "@nur" "@nr" ];
    };
    "NixOS Options" = {
      urls = [{ template = "https://search.nixos.org/options?query={searchTerms}"; }];
      icon = nixIcon;
      definedAliases = [ "@no" ];
    };
  };
in
{
  programs.firefox = {
    enable = true;
    policies = commonPolicies;

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        extensions = commonExtensions;
        settings = commonSettings;
        search = {
          force = true;
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" "NixOS Packages" "NUR Packages" "NixOS Options" ];
          engines = nixSearchEngines // {
            "DuckDuckGo" = {
              urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
              definedAliases = [ "@d" ];
            };
          };
        };
        userChrome = builtins.readFile ./waterfall/userChrome.css;
      };

      dark = {
        id = 1;
        name = "dark";
        isDefault = false;
        extensions = commonExtensions;
        settings = commonSettings;
        containersForce = true;
        containers = {
          r-1 = { id = 1; color = "red"; icon = "circle"; };
          r-2 = { id = 2; color = "blue"; icon = "circle"; };
          p = { id = 3; color = "orange"; icon = "circle"; };
          j = { id = 4; color = "cyan"; icon = "circle"; };
        };
        search = {
          force = true;
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" ];
          engines = {
            "DuckDuckGo" = {
              urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
              definedAliases = [ "@d" ];
            };
          };
        };
      };
    };
  };
}
