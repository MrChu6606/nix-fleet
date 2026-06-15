{ fleetSettings, ... }: {
  containers.searxng = {
    autoStart = true;

    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "${fleetSettings.containers.searxng}/${toString fleetSettings.network.subnetPrefix}";

    extraArgs = { inherit fleetSettings; };

    # Everything inside 'config' runs inside the container
    config = { lib, fleetSettings, ... }: {
      system.stateVersion = "25.05"; 

      # setup tor to fight anti scrape
      services.tor = {
        enable = true;
        client.enable = true;
        settings = {
          SOCKSPort = [{ addr = "127.0.0.1"; port = 9050; }];
        };
      };

      services.searx = {
        enable = true;
        domain = fleetSettings.containers.searxng;

        redisCreateLocally = true;
        
        settings = {
          server = {
            port = 8080;
            bind_address = "0.0.0.0"; # Listen within the container network boundary
            secret_key = "acfe583c3e14089548c186467efb7ebbdef765b643ede173790fc6bc9252b3cf";
          };
          search = {
            safe_search = 0;
            autocomplete = "duckduckgo";
          };
          ui = {
            theme = "simple";
            hotkeys = "vim";
          };

          outgoing = {
            reques_timeout = 4.0;
            max_request_timeout = 10.0;
            useragent_reg = true;

            proxies = {
              http = "socks5h://127.0.0.1:9050";
              https = "socks5h://127.0.0.1:9050";
            };
          };

          engines = [
            { name = "duckduckgo"; engine = "duckduckgo"; shortcut = "ddg"; }
            { name = "google"; engine = "google"; shortcut = "g"; }
            { name = "brave"; engine = "brave"; shortcut = "b"; }
            { name = "wikipedia"; engine = "wikipedia"; shortcut = "w"; }

            { name = "qwant"; engine = "qwant"; shortcut = "qw"; }
          ];

        };
      };

      # Open the container's internal firewall so the host can query it
      networking = {
        firewall.allowedTCPPorts = [ 8080 ];

        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;

        # Tell the container how to reach the internet
        defaultGateway = fleetSettings.network.gateway;
        
        nameservers = fleetSettings.network.dns;
      };

      services.resolved.enable = true;
    };
  };
}
