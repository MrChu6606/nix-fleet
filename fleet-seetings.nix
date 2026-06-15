# This file creates network variables
{
  network = {
    subnetPrefix = 22;
    gateway = "192.168.4.1";
    dns = [ "192.168.4.1" "1.1.1.1" ];
  };

  hosts = {
    sequoia = "192.168.4.27";
    pi = "192.168.4.31";
  };

  containers = {
    searxng = "192.168.4.28";
    mc-20 = "192.168.4.29";
    mc-26 = "192.168.3.30";
  };
}
