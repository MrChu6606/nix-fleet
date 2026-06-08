_:
{
  services.adguardhome = {
    enable = true;

    host = "0.0.0.0";
    port = 8080;

    settings = {
      dns.upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.quad9.net/dns-query"
      ];

      rewrites = [
        {
          domain = "*.home";
          answer = "100.78.76.107";
        }
      ];
    };
  };
}
