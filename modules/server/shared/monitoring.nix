{ fleetSettings, lib, hostname, ... }: {
  services.prometheus.exporters.node = {
    enable = true;
    port = lib.mkDefault fleetSettings.ports.prometheus;
  };

  # Open the port on the firewall for all hosts except sequoia
  networking.firewall.allowedTCPPorts = lib.optionals (hostname != "sequoia") [
    fleetSettings.ports.prometheus
  ];
}
