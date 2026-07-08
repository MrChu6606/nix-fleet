{ fleetSettings, ... }:
{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;

    # Declarative setting injection
    settings = {
      schema_version = 20;

      # Correct Web GUI binding syntax
      http = {
        address = "0.0.0.0"; # Or "127.0.0.1" if Nginx handles all entry points
        port = fleetSettings.ports.adguard.http;
      };

      # Flattend DNS configuration block
      dns = {
        port = fleetSettings.ports.adguard.dns;
        bind_hosts = [ "127.0.0.1" ];
        private_networks = [ "100.64.0.0/10" ];
        
        bootstrap_dns = [
          "1.1.1.1"
          "9.9.9.9"
        ];

        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.quad9.net/dns-query"
        ];
      };

      filtering = {
        filtering_enabled = true;
        rewrites = [
          {
            domain = "*.home";
            answer = fleetSettings.hosts.sequoia.tail;
            enabled = true;
          }
        ];

        filters = [
          {
            enabled = true;
            id = 1;
            name = "AdGuard Base Filter";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          }
          {
            enabled = true;
            id = 2;
            name = "AdAway Mobile Ads";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          }
          {
            enabled = true;
            id = 1718223616;
            name = "OISD Blocklist Big";
            url = "https://big.oisd.nl";
          }
        ];
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ fleetSettings.ports.adguard.dns ];
  };
}
