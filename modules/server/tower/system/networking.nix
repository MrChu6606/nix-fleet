{ fleetSettings, ... }: {
  networking = {
    # Setup switch for managing containers
    bridges.br0.interfaces = [ "eno1" ];
    
    # Static bridge setup
    useDHCP = false;
    interfaces = {
      "br0" = {
        useDHCP = false;
        ipv4.addresses = [{
          address = fleetSettings.sequoia.lan;
          prefixLength = fleetSettings.network.subnetPrefix;
        }];
      };
    };

    defaultGateway = {
      address = fleetSettings.network.gateway;
      interface = "br0";
    };

    nameservers = fleetSettings.network.dns;

    # Firewall Protection
    firewall = {
      enable = true;
    };
  };
}
