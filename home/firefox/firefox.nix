{ pkgs, ... }:

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

    # UI/UX
    "browser.aboutConfig.showWarning" = false;
    "mousewheel.default.delta_multiplier_y" = 100;
    "browser.urlbar.update2" = true;

    # Theme
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;
    "gfx.webrender.al" = true;
    "layers.acceleration.force-enabled" = true;
  };

  # Common extensions for all profiles
  commonExtensions = (with pkgs.unstable.nur.repos.rycee.firefox-addons; [
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
      # ddg Privacy Essentials
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
    "Home-manager Options" = {
      urls = [{ template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=release-24.11"; }];
      icon = nixIcon;
      definedAliases = [ "@ho" ];
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
        extensions.packages = commonExtensions;
        settings = commonSettings;
        search = {
          force = true;
          default = "ddg";
          order = [ "ddg" "NixOS Packages" "NUR Packages" "NixOS Options" ];
          engines = nixSearchEngines // {
            "ddg" = {
              urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
              definedAliases = [ "@d" ];
            };
          };
        };
        userChrome = builtins.readFile ./simplefox/chrome/userChrome.css;
        userContent = builtins.readFile ./simplefox/chrome/userContent.css;
      };

      dark = {
        id = 1;
        name = "dark";
        isDefault = false;
        extensions.packages = commonExtensions;
        settings = commonSettings;
        containersForce = true;
        containers = {
          r-1 = { id = 1; color = "red"; icon = "circle"; };
          r-2 = { id = 2; color = "blue"; icon = "circle"; };
          p = { id = 3; color = "orange"; icon = "circle"; };
          j = { id = 4; color = "turquoise"; icon = "circle"; };
        };
        search = {
          force = true;
          default = "ddg";
          order = [ "ddg" ];
          engines = {
            "ddg" = {
              urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
              definedAliases = [ "@d" ];
            };
          };
        };
        userChrome = builtins.readFile ./simplefox/chrome/userChrome.css;
        userContent = builtins.readFile ./simplefox/chrome/userContent.css;
      };
    };
  };
}
