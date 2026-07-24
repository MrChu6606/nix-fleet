{ fleetSettings, ... }:
let
  # Helper function to map a service string to an Nginx virtualHost attribute pair
  mkLocalProxy = host: service: {
    name = "${service}.home";
    value = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString fleetSettings.${host}.ports.${service}}";
      };
    };
  };

  # Generate the repetitive localhost virtual hosts for Sequoia
  sequoiaStandardHosts = builtins.listToAttrs (map (mkLocalProxy "sequoia") [
    "hypermind"
    "hyperswarm"
    "navidrome"
    "prowlarr"
    "grafana"
    "glances"
    "lidarr"
  ]);

  # Non-standard or unique mappings that break the cookie-cutter pattern
  customHosts = {
    "searxng.home" = {
      locations."/" = {
        proxyPass = "http://${fleetSettings.sequoia.containers.searxng}:${toString fleetSettings.ports.adguard.http}";
        proxyWebsockets = true;
      };
    };

    "adguard.home" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString fleetSettings.sequoia.ports.adguard.http}";
      };
    };

    "adguard-pi.home" = {
      locations."/" = {
        proxyPass = "http://${fleetSettings.juniper.lan}:${toString fleetSettings.juniper.ports.adguard.http}";
        proxyWebsockets = true;
      };
    };

    "sabnzbd.home" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString fleetSettings.sequoia.ports.sabnzbd}";
        
        # Explicitly pass the original host header down to SABnzbd
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
in
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Merge the dynamically generated set with the custom overrides
    virtualHosts = sequoiaStandardHosts // customHosts;
  };

  networking.firewall.allowedTCPPorts = [ fleetSettings.sequoia.ports.nginx ];
}
