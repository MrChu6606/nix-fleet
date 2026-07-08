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
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.adguard}";
        };
      };

      "adguard-pi.home" = {
        locations."/" = {
          proxyPass = "http://${fleetSettings.hosts.juniper.lan}:${toString fleetSettings.ports.adguard}";
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
          proxyPass = "http://127.0.0.1:61208/";
        };
      };

      "grafana.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString fleetSettings.ports.sequoia.grafana}";
        };
      };

      "navidrome.home" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:4533";
        };
      };
    };
  };
  # open 443 when https is setup
  # for some reason going to the browser at this port will
  # point to a blank adguard home web page
  networking.firewall.allowedTCPPorts = [ 80 ]; 
}
