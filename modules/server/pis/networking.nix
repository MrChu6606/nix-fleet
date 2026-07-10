{ fleetSettings, config, ... }:
let 
  host = config.netowrking.hostName;
  hostConfig = fleetSettings.hosts.${host} or null;
in {
  networking = if hostConfig != null then {
    firewall.enable = true;

    useDHCP = false;
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = hostConfig.lan;
        prefixLength = fleetSettings.network.subnetPrefix;
      }];
    };

    defaultGateway = fleetSettings.network.gateway;
    nameservers = fleetSettings.network.dns;
  } else {
    firewall.enable = true;
    useDHCP = true;
  };
}
