_: {
  
  # Configure hostname
  networking.hostName = "sequoia";

  networking = {
    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 53 80 3001 3002 19999 ];
      allowedUDPPorts = [ 53 ];
    };

    #Setup switch for managing containers
    bridges.br0.interfaces = [ "eno1" ]; # Adjust interface accordingly
    
    # Get bridge-ip with DHCP
    useDHCP = false;
    interfaces."br0".useDHCP = true;

    # Set bridge-ip static
    interfaces."br0".ipv4.addresses = [{
      address = "192.168.4.27";
      prefixLength = 22;
    }];
    defaultGateway = "192.168.4.1";
    nameservers = [ "192.168.4.1" "1.1.1.1" ];
  };
}
