_: {
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    avahi = {
      enable = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    resolved = {
      enable = true;
      settings.Resolve.MultiCastDNS = "yes";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 5353 ]; 
  };
}
