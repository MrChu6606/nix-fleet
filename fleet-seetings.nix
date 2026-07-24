# This file creates network variables
{
  sequoia = {
    lan = "192.168.5.100";
    tail = "100.123.59.57";

    containers = {
      searxng = "192.168.5.101";
      mc-20 = "192.168.5.102";
      mc-26 = "192.168.5.103";
      mc-ts = {
        lan = "192.168.4.104";
        tail = "100.84.69.97";
      };
    };

    ports = {
      # Media Server
      navidrome = 4533;
      sabnzbd = 8085;
      lidarr = 8686;
      prowlarr = 9696;

      # Infrastructure
      prometheus = {
        exporter = 9100;
        service = 9090;
      };
      grafana = 3000;
      glances = 61208;
      nginx = 80;
      adguard = {
        http = 3080;
        dns = 53;
      };

      # Others
      hypermind = 3001;
      hyperswarm = 3002;
    };

  };

  juniper = {
    lan = "192.168.5.99";
    tail = "100.108.233.1";

    ports = {
      prometheus = 9100;
      adguard = {
        http = 3080;
        dns = 53;
      };
    };
  };

  rowan = {
    lan = "192.168.5.98";
    wifi = "192.168.5.97";
  };

  aspen = {
    lan = "192.168.5.96";
    ports = {
      ollama = 11434;
      librechat = 3080;
      whisper = 10300;
      piper = 10200;
      wakeWord = 10400;
    };
  };

  network = {
    subnet = "192.168.4.0";
    subnetPrefix = 22;
    gateway = "192.168.4.1";
    dns = [ "192.168.4.1" "1.1.1.1" ];
  };
}
