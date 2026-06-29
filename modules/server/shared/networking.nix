_: {
  
  # Configure ssh
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
      };
    };

    # Setup Aahi to broadcast hostname
    avahi =   {
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
