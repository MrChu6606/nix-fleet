_: {
  
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ 22 80 53];
    allowedUDPPorts = [ ];
  };

  # Configure hostname
  networking.hostName = "juniper";
}
