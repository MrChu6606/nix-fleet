{ fleetSettings, ... }:
{
  services.adguardhome = {
    enable = true;

    host = "0.0.0.0";
    port = fleetSettings.ports.adguard;

    # makes this file the config file and ignores web dashboard configs
    mutableSettings = false;

    settings = {
      dns = {
        bootstrap_dns = [
          "1.1.1.1"
          "9.9.9.9"
        ];

        upstream_dns = [
          "https://dns.cloudflare.com/dns-query"
          "https://dns.quad9.net/dns-query"
        ];

        private_networks = [ "100.64.0.0/10" ];
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
            id = 1; # AdGuard Base List
            name = "AdGuard Base Filter";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          }
          {
            enabled = true;
            id = 2; # AdAway Mobile Ads
            name = "AdAway Mobile Ads";
            url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          }
          {
            enabled = true;
            id = 1718223616; # Example tracking list (you can pick arbitrary high integers for custom IDs)
            name = "OISD Blocklist Big";
            url = "https://big.oisd.nl";
          }
        ];
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 53 ];
  };
}
