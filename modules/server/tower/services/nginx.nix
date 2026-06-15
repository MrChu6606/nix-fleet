{ fleetSettings, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "searxng.home" = {
        locations."/" = {
          proxyPass = "http://${fleetSettings.containers.searxng}:8080";
          proxyWebsockets = true;
        };
      };

      "adguard.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      };

      "adguard-pi.home" = {
        locations."/" = {
          proxyPass = "http://${fleetSettings.hosts.pi}:8080";
          proxyWebsockets = true;
        };
      };

      "hypermind.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3002";
        };
      };

      "hyperswarm.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
        };
      };

      "glances.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:61208/";
        };
      };
    };
  };
}
