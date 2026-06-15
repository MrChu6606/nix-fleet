{ fleetSettings, ... }: {
  
  networking = {
    firewall = {
      enable = true;

      allowedTCPPorts = [ 22 8080 53];
      allowedUDPPorts = [ 53 ];
    };

    useDHCP = false;
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = fleetSettings.hosts.pi;
        prefixLength = fleetSettings.network.subnetPrefix;
      }];
    };

    defaultGateway = fleetSettings.network.gateway;
    nameservers = fleetSettings.network.dns;

    hostName = "juniper";
  };
}
