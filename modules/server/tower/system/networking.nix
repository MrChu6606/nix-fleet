{ fleetSettings, ... }: {
  
  # Configure hostname
  networking.hostName = "sequoia";

  networking = {
    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 53 80 3001 3002 61208 ];
      allowedUDPPorts = [ 53 ];
    };

    #Setup switch for managing containers
    bridges.br0.interfaces = [ "eno1" ];
    
    # Get bridge-ip with DHCP
    useDHCP = false;
    interfaces."br0".useDHCP = false;

    # Set bridge-ip static
    interfaces."br0".ipv4.addresses = [{
      address = fleetSettings.hosts.sequoia;
      prefixLength = 22;
    }];
    defaultGateway = fleetSettings.network.gateway;
    nameservers = fleetSettings.network.dns;
  };
}
