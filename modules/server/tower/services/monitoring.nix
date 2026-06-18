{ fleetSettings, config, ... }: {
  # glances for system metrics
  services.glances.enable = true;

  services = {
    prometheus = {
      # Grabs metrics from this machine
      exporters.node = {
        enable = true;
        port = 9100;
      };
      # Main prometheus service
      enable = true;
      port = 9090;

      scrapeConfigs = [
        # Scrap local host
        {
          job_name = "main-server-host";
          static_configs = [{ targets = [ "127.0.0.1:9100" ]; }];
        }
        # Scrap docker container resource states
        {
          job_name = "main-server-containers";
          static_configs = [{ targets = [ "127.0.0.1:8081" ]; }];
        }
        # Checks mc containers
        {
          job_name = "minecraft-lan-bridge";
          static_configs = [{
            targets = [
              fleetSettings.containers.mc-20
              fleetSettings.containers.mc-26
            ];
          }];
        }
        {
          job_name = "juniper";
          static_configs = [{
            targets = [ (fleetSettings.hosts.juniper + ":9100") ];
          }];
        }

      ];
    };

    cadvisor = {
      enable = true;
      port = 8081;
    };

    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "0.0.0.0";
          http_port = 3000;
        };
      };
    };
  };
  # injects env file into grafana for secrets
  systemd.services.grafana.serviceConfig.EnvironmentFile = config.sops.secrets.grafana_env.path;
                              # glances grafana
  networking.firewall.allowedTCPPorts = [ 61208 3000 ];
}
