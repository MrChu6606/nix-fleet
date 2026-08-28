{ config, pkgs, nur, ... }:

let
  firefox-addons = nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons;
in
{
  programs.zen-browser = {
    enable = true;

    profiles.default = {
      isDefault = true;

      # Native Zen Theme Store Mods
      mods = [
        "better-unloaded-tabs"
        "better-ctrltab"
        "transparent-zen"
      ];

      # Verified Firefox Extensions via NUR rycee scope
      extensions = with firefox-addons; [
        ublock-origin
        vimium
        privacy-badger
        clearurls
        consent-o-matic
        decentraleyes
        disconnect
        return-youtube-dislike
        search-by-image
        ttv-lol-pro
        channel-points-drop-attendant-for-twitch
      ];

      # Native Zen Spaces with custom icons
      spaces = [
        {
          name = "General";
          icon = "chrome://browser/skin/settings.svg";
        }
        {
          name = "School";
          icon = "chrome://global/skin/icons/edit.svg";
        }
        {
          name = "Server";
          icon = "chrome://browser/skin/developer.svg";        }
        {
          name = "Reading";
          icon = "chrome://browser/skin/bookmark.svg";
        }
      ];

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
