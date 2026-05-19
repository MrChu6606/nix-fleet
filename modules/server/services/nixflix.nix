{ config, ... }:
{
  # This is just the default template
  sops.secrets = {
    "sonarr/api_key" = {};
    "sonarr/password" = {};
    "radarr/api_key" = {};
    "radarr/password" = {};
    "lidarr/api_key" = {};
    "lidarr/password" = {};
    "prowlarr/api_key" = {};
    "prowlarr/password" = {};
    "indexer-api-keys/DrunkenSlug" = {};
    "jellyfin/alice_password" = {};
    "seerr/api_key" = {};
    "wireguard/conf" = {};
  };

  nixflix = {
    enable = true;
    mediaDir = "/media";
    stateDir = "/appdata/nixflix";
    mediaUsers = ["nic"];

    theme = {
      enable = true;
      name = "overseerr";
    };

    # Reverse proxy (choose nginx or caddy, not both)
        # nginx = {
        #   enable = true;
        #   addHostsEntries = true; # Disable this if you have your own DNS configuration
        # };
    caddy = {
      enable = true;
      addHostsEntries = true;
    };

    postgres.enable = true;

    sonarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."sonarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."sonarr/password".path;
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."radarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."radarr/password".path;
      };
    };

    recyclarr = {
      enable = true;
      cleanupUnmanagedProfiles = true;
    };

    lidarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."lidarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."lidarr/password".path;
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKey._secret = config.sops.secrets."prowlarr/api_key".path;
        hostConfig.password._secret = config.sops.secrets."prowlarr/password".path;
        indexers = [
          {
            name = "DrunkenSlug";
            apiKey._secret = config.sops.secrets."indexer-api-keys/DrunkenSlug".path;
          }
        ];
      };
    };

    jellyfin = {
      enable = true;
      apiKey._secret = config.sops.secrets."jellyfin/api_key".path;
      users = {
        admin = {
          mutable = false;
          policy.isAdministrator = true;
          password._secret = config.sops.secrets."jellyfin/alice_password".path;
        };
      };
    };

    seerr = {
      enable = true;
      apiKey._secret = config.sops.secrets."seerr/api_key".path;
    };

    vpn = {
      enable = true;
      wgConfFile = config.sops.secrets."wireguard/conf".path;
      accessibleFrom = [ "192.168.4.0/24" ];
    };
  };

