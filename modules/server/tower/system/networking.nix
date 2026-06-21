{ fleetSettings, ... }: {
  
  # Configure hostname
  networking.hostName = "sequoia";

  networking = {
    firewall.enable = true;

    #Setup switch for managing containers
    bridges.br0.interfaces = [ "eno1" ];
    
    # Get bridge-ip with DHCP
    useDHCP = false;
    interfaces."br0".useDHCP = false;

    # Set bridge-ip static
    interfaces."br0".ipv4.addresses = [{
      address = fleetSettings.hosts.sequoia.lan;
      prefixLength = 22;
    }];

    defaultGateway = {
      address = fleetSettings.network.gateway;
      interface = "br0";
    };

    nameservers = fleetSettings.network.dns;
  };
}
