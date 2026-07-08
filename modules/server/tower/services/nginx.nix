
{ fleetSettings, ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "searxng.home" = {
        locations."/" = {
          proxyPass = "http://${fleetSettings.containers.searxng}:${toString fleetSettings.ports.adguard.http}";
          proxyWebsockets = true;
        };
      };

      "adguard.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.adguard.http}";
        };
      };

      "adguard-pi.home" = {
        locations."/" = {
          proxyPass = "http://${fleetSettings.hosts.juniper.lan}:${toString fleetSettings.ports.adguard.http}";
          proxyWebsockets = true;
        };
      };

      "hypermind.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.sequoia.hypermind}";
        };
      };

      "hyperswarm.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.sequoia.hyperswarm}";
        };
      };

      "glances.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.sequoia.glances}/";
        };
      };

      "grafana.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.sequoia.grafana}";
        };
      };

      "navidrome.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.sequoia.navidrome}";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ fleetSettings.ports.sequoia.nginx ];
}
