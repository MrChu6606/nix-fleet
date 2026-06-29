{ fleetSettings, ... }: {
  
  networking = {
    firewall.enable = true;

    useDHCP = true;
    interfaces.eth0 = {
      useDHCP = true;
      #  ipv4.addresses = [{
      #    address = fleetSettings.hosts.juniper.lan;
      #    prefixLength = fleetSettings.network.subnetPrefix;
      #  }];
    };

    # defaultGateway = fleetSettings.network.gateway;
    # nameservers = fleetSettings.network.dns;

    hostName = "juniper";
  };
}
