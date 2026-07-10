{ fleetSettings, ... }: {
  services.prometheus.exporters.node = {
    enable = true;
    port = fleetSettings.ports.juniper.prometheus;
  };

  networking.firewall.allowedTCPPorts = [ 9100 ];
}
