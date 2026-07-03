_: {
  networking = {
    hostName = "cedar";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
}
