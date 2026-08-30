{ config, pkgs, nur, ... }:

let
  firefox-addons = nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons;
in
{
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
    };

    profiles.default = {
      settings = {
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.urlbar.behavior" = "float";
      };

      # Native Zen Theme Store Mods
      mods = [
        "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # better unloaded tabs
        "72f8f48d-86b9-4487-acea-eb4977b18f21" # better ctrl tab
        "642854b5-88b4-4c40-b256-e035532109df" # transparent zen
        "5941aefd-67b0-453d-9b62-9071a31cbb0d" # Smaller compact mode
        "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
      ];

      # Verified Firefox Extensions via NUR rycee scope
      extensions.packages = with firefox-addons; [
        ublock-origin
        vimium
        privacy-badger
        clearurls
        consent-o-matic
        decentraleyes
        disconnect
        darkreader
        zen-internet
        search-by-image
        addy_io
        return-youtube-dislikes
        betterttv
        twitch-auto-points
      ];

      search = {
        force = true;
        default = "ddg";
      };

      bookmarks = {
        force = true; # Im not sure if theres an alternative to this
        settings = [
          {
            name = "Basic Stuff";
            menu = true;
            bookmarks = [
              {
                name = "Nix Search";
                url = "https://search.nixos.org";
                keywork = "nix";
              }
              {
                name = "Gemini";
                url = "https://gemini.google.com";
                keyword = "gemini";
              }
              {
                name = "Chat GPT";
                url = "https://chatgpt.com/";
                keyword = "chat";
              }
            ];
          }
          {
            name = "Google suite";
            toolbar = true;
            bookmarks = [
              {
                name = "Google Docs";
                url = "https://docs.google.com";
                keyword = "docs";
              }
              {
                name = "Google Drive";
                url = "https://drive.google.com";
                keyword = "drive";
              }
            ];
          }
        ];
      };

      spacesForce = true; # Delete spaces not declared here
      # Native Zen Spaces with custom icons
      spaces = {

        "General" = {
          id = "6020ca97-2c4a-4e27-9d8a-df0a17391eab";
          position = 1000;
          icon = "chrome://browser/skin/settings.svg";
        };

        "School" = {
          id = "d6b55af5-965d-4cd8-91c3-b9dda7ffa54e";
          position = 2000;
          icon = "chrome://global/skin/icons/edit.svg";
        };

        "Server" = {
          id = "621a8938-ed42-489c-8628-01e9558881bc";
          position = 3000;
          icon = "chrome://browser/skin/developer.svg";
        };

        "Reading" = {
          id = "c962d50f-ed1b-4807-9f44-cdfecebd5219";
          position = 4000;
          icon = "chrome://browser/skin/bookmark.svg";
        };

      };

      # Dynamic Noctalia imports
      userChrome = ''
        @import url("file://${config.xdg.cacheHome}/noctalia/zen-browser/zen-userChrome.css");
      '';

      userContent = ''
        @import url("file://${config.xdg.cacheHome}/noctalia/zen-browser/zen-userContent.css");
      '';
    };
  };
}
