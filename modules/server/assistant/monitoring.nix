{ fleetSettings, ... }: {
  services.prometheus.exporters.node = {
    enable = true;
    port = fleetSettings.ports.prometheus;
  };

  networking.firewall.allowedTCPPorts = [ fleetSettings.ports.prometheus ];
}
