{ fleetSettings, pkgs, ... }:let 
  mosquittoConf = pkgs.writeText "mosquitto.conf" ''
    listener 1883 0.0.0.0
    allow_anonymous true
  '';
  z2mConf = pkgs.writeText "configuration.yaml" ''
    homeassistant: true
    permit_join: false
    mqtt:
      base_topic: zigbee2mqtt
      server: mqtt://mosquitto:${toString fleetSettings.sequoia.ports.mosquitto}
    serial:
      port: /dev/ttyACM0
      adapter: zstack
    frontend:
      port: 8080
      host: 0.0.0.0
    advanced:
      network_key: GENERATE
  '';
in {
  virtualisation.arion = {
    backend = "podman-socket";

    projects.home-automation.settings = {
      project.name = "home-automation";

      services = {
        homeassistant = {
          service = {
            container_name = "homeassistant";
            image = "ghcr.io/home-assistant/home-assistant:stable";

            restart = "unless-stopped";

            network_mode = "host";

            privileged = true;

            volumes = [
              "/appdata/home-automation/home-assistant:/config"
              "/etc/localtime:/etc/localtime:ro"
              "/run/dbus:/run/dbus:ro"
            ];

            environment = {
              TZ = toString fleetSettings.network.tz;
            };
          };
        };

        mosquitto = {
          service = {
            container_name = "mosquitto";
            image = "eclipse-mosquitto:2";

            restart = "unless-stopped";

            ports = [
              "127.0.0.1:${toString fleetSettings.sequoia.ports.mosquitto}:1883"
            ];

            volumes = [
              "/appdata/home-automation/mosquitto/data:/mosquitto/data"
              "/appdata/home-automation/mosquitto/log:/mosquitto/log"
              "${mosquittoConf}:/mosquitto/config/mosquitto.conf:ro"
            ];
          };
        };

        zigbee2mqtt = {
          service = {
            container_name = "zigbee2mqtt";
            image = "ghcr.io/koenkk/zigbee2mqtt:latest";

            restart = "unless-stopped";

            ports = [
              "127.0.0.1:${toString fleetSettings.sequoia.ports.zigbee}:8080"
            ];

            volumes = [
              "/appdata/home-automation/zigbee2mqtt:/app/data"
              "/run/udev:/run/udev:ro"
            ];

            devices = [
              "/dev/serial/by-id/usb-SONOFF_SONOFF_Dongle_Plus_CC2674P10_90352febbffef01197d3f41f364a576b-if00-port0:/dev/ttyACM0"
            ];

            environment = {
              TZ = toString fleetSettings.network.tz;
            };

            depends_on = [
              "mosquitto"
            ];
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /appdata/home-automation 0755 root root -"
    "d /appdata/home-automation/home-assistant 0755 root root -"
    "d /appdata/home-automation/mosquitto 0755 root root -"
    "d /appdata/home-automation/mosquitto/data 0755 root root -"
    "d /appdata/home-automation/mosquitto/log 0755 root root -"
    "d /appdata/home-automation/zigbee2mqtt 0755 root root -"
    "C /appdata/home-automation/zigbee2mqtt/configuration.yaml 0644 root root - ${z2mConf}"
  ];

  networking.firewall.allowedTCPPorts = [ fleetSettings.sequoia.ports.homeassistant ];
}
