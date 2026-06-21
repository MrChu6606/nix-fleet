{ config, ... }: {
  # 1. Create a unified group for your media pipeline
  users.groups.media = { };

  # Ensure your personal user is part of the media group so you can manage files manually
  users.users.nic.extraGroups = [ "media" ];

  # 2. Navidrome - The Front-End Streamer
  services = {
    navidrome = {
      enable = true;
      settings = {
        Address = "0.0.0.0";
        Port = 4533;
        MusicFolder = "/media/music";
        ScanSchedule = "@every 15m";
        LogLevel = "info";
      };
    };

    # 3. SABnzbd - The Usenet Download Engine
    sabnzbd = {
      enable = true;
      # Port 563
      group = "media";
    };

    # 4. Lidarr - The Music Collection & Automation Manager
    lidarr = {
      enable = true;
      # Port 8686
      group = "media";
      settings.server = {
        port = 8686;
        bindaddress = "127.0.0.1";
      };
      environmentFiles = [ config.sops.secrets.lidarr-env.path ];
    };

    # 5. Prowlarr - The Indexer Sync
    prowlarr = {
      enable = true;
      settings = {
        server = {
          port = 9696;
          bindaddress = "127.0.0.1";
        };
      };
      environmentFiles = [ config.sops.secrets.prowlarr_env.path];
    };
  };

  # 6. Ensure system directories exist with correct permissions on boot
  systemd.tmpfiles.rules = [
    "d /media/music 0775 lidarr media -"
    "d /media/downloads/incomplete 0775 sabnzbd media -"
    "d /media/downloads/complete 0775 sabnzbd media -"
  ];
}
