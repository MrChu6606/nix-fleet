_:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "searxng.home" = {
        locations."/" = {
          proxyPass = "http://192.168.4.28:8080";
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
          proxyPass = "http://192.168.4.23";
        };
      };
    };
  };
}
