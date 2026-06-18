_: {
  
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

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 5353 ];
  };
}
