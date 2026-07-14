_: {
  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    avahi = {
      enable = true;
      openFirewall = true; # UDP 5353
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
    enable = true;
    allowedTCPPorts = [ 22 ];
    trustedInterfaces = [ "end0" "eth0" "en*" "wl*" "wlan*" ];
  };
}
