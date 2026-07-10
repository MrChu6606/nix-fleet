{ fleetSettings, config, lib, ... }:
let 
  host = config.networking.hostName;
  hostConfig = fleetSettings.hosts.${host} or null;
  isStatic = hostConfig != null;
in {
  networking = {
    firewall.enable = true;

    useDHCP = !isStatic;
    # Conditionally create static interfaces if hostConfig exists
    # otherwise use DHCP
    interfaces.eth0 = lib.mkIf isStatic {
      useDHCP = false;
      ipv4.addresses = [{
        address = hostConfig.lan;
        prefixLength = fleetSettings.network.subnetPrefix;
      }];
    };

    defaultGateway = lib.mkIf isStatic fleetSettings.network.gateway;
    nameservers = lib.mkIf isStatic fleetSettings.network.dns;
  };
}
