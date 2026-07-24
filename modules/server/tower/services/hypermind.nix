{ fleetSettings, ... }: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {

      # Original Hypermind
      hypermind = {
        image = "ghcr.io/lklynet/hypermind:latest";
        # use host networking for Hyperswarm DHT to find peers
        extraOptions = [ "--network=host" ];
        environment = {
          PORT = toString fleetSettings.sequoia.ports.hypermind;
          ENABLE_CHAT = "true";
          ENABLE_MAP = "true";
        };
      };

      # Hypermind Swarm
      hypermind-swarm = {
        image = "ghcr.io/lklynet/hypermind-swarm:latest";
        extraOptions = [ "--network=host" ];
        environment = {
          PORT = toString fleetSettings.sequoia.ports.hyperswarm;
        };
      }; 
    };
  };
}
