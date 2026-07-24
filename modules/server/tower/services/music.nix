{ config, pkgs, fleetSettings, ... }:
let
  # Network Target Boundary
  # Keep as "127.0.0.1" to isolate services securely behind your proxy/Tailscale.
  # Change to "0.0.0.0" only if you want to open services to the local physical LAN.
  targetHost = "127.0.0.1";

  # Bandwidth Management Profiles (Protects host networks from throttling)
  daytimeSpeedLimit   = "20M";  # Base throttle active during waking hours
  nighttimeSpeedLimit = "30M";    # 0 = Unlimited (unleashed while everyone sleeps)

  # Automated Clock Schedules (24-Hour Format)
  nightScheduleHour   = "1";    # When to drop throttle barriers (e.g., 1:00 AM)
  dayScheduleHour     = "7";    # When to restore safe caps (e.g., 7:00 AM)
in
{
  # Unified Shared Media Permissions Architecture
  users.groups.media = { };
  users.users.nic.extraGroups = [ "media" ];

  services = {
    # Navidrome - The Front-End Media Streamer
    navidrome = {
      enable = true;
      group = "media"; # Align permissions so Navidrome can parse Lidarr imports
      settings = {
        Address = targetHost;
        Port = fleetSettings.sequoia.ports.navidrome;
        MusicFolder = "/media/music";
        ScanSchedule = "@every 15m";
        LogLevel = "info";
      };
    };

    sabnzbd = {
      enable = true;
      group = "media";
      configFile = null;
      secretFiles = [ config.sops.secrets.sabnzbd_secrets.path ];
      settings = {
        misc = {
          port = fleetSettings.sequoia.ports.sabnzbd;
          host = "0.0.0.0";
          bandwidth_max = daytimeSpeedLimit; 
          download_dir = "/media/downloads/incomplete/";
          complete_dir = "/media/downloads/complete/";
          permissions = "775";

          # Automated Night-Owl Scheduling Matrix
          # Syntax: "hour minute day_of_week action [argument]" (0 = Daily)
          scheduler = 
            "${nightScheduleHour} 0 0 speedlimit ${nighttimeSpeedLimit}, ${dayScheduleHour} 0 0 speedlimit ${daytimeSpeedLimit}";
        };
        servers = {
          "frugal-main" = {
            enable = true;
            host = "news.frugalusenet.com";
            name = "frugal-main";
            displayname = "main";
            connections = 25;
            ssl = true;
            port = 443;
            optional = true;
            priority = 0;
          };
          "frugal-backup" = {
            enable = true;
            host = "bonus.frugalusenet.com";
            name = "frugal-backup";
            displayname = "backup";
            connections = 25;
            ssl = true;
            port = 443;
            optional = true;
            priority = 1;
          };
        };
        categories = {
          music = {
            dir = "music";
            priority = 1;
            pp = 3;
            script = "None";
          };
        };
      };
    };

    # Lidarr - The Music Collection & Automation Manager
    lidarr = {
      enable = true;
      group = "media";
      settings = {
        update = { mechanism = "external"; }; # Strictly immutable/declarative tracking via flakes
        server = {
          port = fleetSettings.sequoia.ports.lidarr;
          bindaddress = targetHost;
        };
        auth.required = "DisabledForLocalAddresses";
      };
      environmentFiles = [ config.sops.secrets.lidarr_env.path ];
    };

    # Prowlarr - The Indexer Synchronization Layer
    prowlarr = {
      enable = true;
      settings = {
        update = { mechanism = "external"; };
        server = {
          port = fleetSettings.sequoia.ports.prowlarr;
          bindaddress = targetHost;
        };
        auth.required = "DisabledForLocalAddresses";
      };
      environmentFiles = [ config.sops.secrets.prowlarr_env.path ];
    };
  };

  systemd = {
    # Automated Persistent Storage Scaffolding & Permissions Enforcement
    tmpfiles.rules = [
      "d /media/music 0775 lidarr media -"
      "d /media/downloads/incomplete 0775 sabnzbd media -"
      "d /media/downloads/complete 0775 sabnzbd media -"
    ];
    services = {
      # Tell prowlarr how to talk to sabnzbd
      prowlarr = {
        after = [ "sabnzbd.service" ]; 
        path = [ pkgs.curl pkgs.gnused ];

        serviceConfig.ExecStartPost = let
          linkDownloader = pkgs.replaceVarsWith {
            src = ../../../../lib/connect-to-sabnzbd.sh;
            dir = "bin";
            isExecutable = true;
            replacements = {
              scriptPath = pkgs.lib.makeBinPath [ pkgs.curl pkgs.gnused pkgs.gnugrep ];
              serviceName = "PROWLARR";
              targetAppPort = toString fleetSettings.sequoia.ports.prowlarr;
              downloaderPort = toString fleetSettings.sequoia.ports.sabnzbd;
              categoryName = "none";
              categoryValue = "";
              targetAppEnvPath = config.sops.secrets.prowlarr_env.path;
              downloaderSecretsPath = config.sops.secrets.sabnzbd_secrets.path;
            };
          };
        in "-+${linkDownloader}/bin/connect-to-sabnzbd.sh";
      };

      # Tell lidarr how to talk to sabnzbd
      lidarr = {
        after = [ "sabnzbd.service" ]; 
        path = [ pkgs.curl pkgs.gnused ];

        serviceConfig.ExecStartPost = let
          linkDownloader = pkgs.replaceVarsWith {
            src = ../../../../lib/connect-to-sabnzbd.sh;
            dir = "bin";
            isExecutable = true;
            replacements = {
              scriptPath = pkgs.lib.makeBinPath [ pkgs.curl pkgs.gnused pkgs.gnugrep pkgs.coreutils ];
              serviceName = "LIDARR";
              targetAppPort = toString fleetSettings.sequoia.ports.lidarr;
              downloaderPort = toString fleetSettings.sequoia.ports.sabnzbd;
              categoryName = "musicCategory";
              categoryValue = "music";
              targetAppEnvPath = config.sops.secrets.lidarr_env.path;
              downloaderSecretsPath = config.sops.secrets.sabnzbd_secrets.path;
            };
          };
        in "-+${linkDownloader}/bin/connect-to-sabnzbd.sh";
      };

      prowlarr-link-lidarr = {
        description = "Link Lidarr to Prowlarr API indexer sync";
        after = [ "prowlarr.service" "lidarr.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = let
            linkApp = pkgs.replaceVarsWith {
              src = ../../../../lib/connect-to-prowlarr.sh;
              dir = "bin";
              isExecutable = true;
              replacements = {
                scriptPath = pkgs.lib.makeBinPath [ pkgs.curl pkgs.gnused pkgs.gnugrep ];
                prowlarrPort = toString fleetSettings.sequoia.ports.prowlarr;
                subAppPort = toString fleetSettings.sequoia.ports.lidarr;
                subAppName = "Lidarr";
                prowlarrEnvPath = config.sops.secrets.prowlarr_env.path;
                subAppEnvPath = config.sops.secrets.lidarr_env.path;
              };
            };
          in "${linkApp}/bin/connect-to-prowlarr.sh";
        };
      };
    };
  };
}
