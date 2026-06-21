# This file creates network variables
{
  network = {
    subnet = "192.168.4.0";
    subnetPrefix = 22;
    gateway = "192.168.4.1";
    dns = [ "192.168.4.1" "1.1.1.1" ];
  };

  hosts = {
    sequoia = {
      lan = "192.168.5.100";
      tail = "100.123.59.57";
    };
    juniper = {
      lan = "192.168.5.99";
      tail = "100.108.233.1";
    };
  };

  containers = {
    searxng = "192.168.5.101";
    mc-20 = "192.168.5.102";
    mc-26 = "192.168.5.103";
    mc-ts = {
      lan = "192.168.4.104";
      tail = "100.99.43.45";
    };
  };
}
