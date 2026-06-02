_: {
  virtualization.oci-containers = {
    backend = "docker";
    containers = {

      # Original Hypermind
      hypermind = {
        image = "ghcr.io/lklynet/hypermind:latest";
        # use host networking for Hyperswarm DHT to find peers
        extraOptions = [ "--network=host" ];
        environment = {
          PORT = "3002";
          ENABLE_CHAT = "true";
          ENABLE_MAP = "true";
        };
      };

      # Hypermind Swarm
      hypermind-swarm = {
        image = "ghcr.io/lklynet/hypermind-swarm:latest";
        extraOptions = [ "--network=host" ];
        environment = {
          PORT = "3001"; # Keep it on a different port to avoid collisions
        };
      }; 
    };
  };
}
