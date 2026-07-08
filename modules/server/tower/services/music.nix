{ config, fleetSettings, ... }:
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
        Port = fleetSettings.ports.sequoia.navidrome;
        MusicFolder = "/media/music";
        ScanSchedule = "@every 15m";
        LogLevel = "info";
      };
    };

    sabnzbd = {
      enable = true;
      group = "media";
      secretFiles = [ config.sops.secrets.sabnzbd_secrets.path ];
      settings = {
        misc = {
          port = "${fleetSettings.ports.sequoia.sabnzbd}";
          host = targetHost;
          bandwidth_max = daytimeSpeedLimit; 

          # Automated Night-Owl Scheduling Matrix
          # Syntax: "hour minute day_of_week action [argument]" (0 = Daily)
          scheduler = [
            "${nightScheduleHour} 0 0 speedlimit ${nighttimeSpeedLimit}"
            "${dayScheduleHour} 0 0 speedlimit ${daytimeSpeedLimit}"
          ];
        };
      };
    };

    # 4. Lidarr - The Music Collection & Automation Manager
    lidarr = {
      enable = true;
      group = "media";
      settings = {
        update = { mechanism = "external"; }; # Strictly immutable/declarative tracking via flakes
        server = {
          port = fleetSettings.ports.sequoia.lidarr;
          bindaddress = targetHost;
        };
      };
      environmentFiles = [ config.sops.secrets.lidarr_env.path ];
    };

    # Prowlarr - The Indexer Synchronization Layer
    prowlarr = {
      enable = true;
      settings = {
        update = { mechanism = "external"; };
        server = {
          port = fleetSettings.ports.sequoia.prowlarr;
          bindaddress = targetHost;
        };
      };
      environmentFiles = [ config.sops.secrets.prowlarr_env.path ];
    };
  };

  # 6. Automated Persistent Storage Scaffolding & Permissions Enforcement
  systemd.tmpfiles.rules = [
    "d /media/music 0775 lidarr media -"
    "d /media/downloads/incomplete 0775 sabnzbd media -"
    "d /media/downloads/complete 0775 sabnzbd media -"
  ];
}
