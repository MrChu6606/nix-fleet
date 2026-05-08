{ ... }: {
  
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ 22 80 81 443 ];
    allowedUDPPorts = [ ];
  };

  # Configure hostname
  networking.hostName = "Sequoia";

  # Configure ssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Setup Aahi to broadcast hostname
  services.avahi =   {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
