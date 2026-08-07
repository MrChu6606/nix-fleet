{ pkgs, fleetSettings, ... }:
let
  haIp = fleetSettings.sequoia.containers.homeassistant;
  haConfigDir = "/var/lib/homeassistant-config";
in
{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  # Ensure state directory exists on the host
  systemd.tmpfiles.rules = [
    "d ${haConfigDir} 0755 root root -"
  ];

  # Declaratively initialize/append configuration.yaml without locking out UI edits
  systemd.services.homeassistant-config-init = {
    description = "Initialize Home Assistant configuration.yaml if missing/incomplete";
    before = [ "podman-homeassistant.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "init-ha-config" ''
        CONFIG_FILE="${haConfigDir}/configuration.yaml"
        
        # Touch file if it doesn't exist
        if [ ! -f "$CONFIG_FILE" ]; then
          cat <<EOF > "$CONFIG_FILE"
# Home Assistant Configuration
default_config:

http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.4.0/22
EOF
        else
          # Append trusted_proxies configuration if missing
          if ! grep -q "use_x_forwarded_for" "$CONFIG_FILE"; then
            cat <<EOF >> "$CONFIG_FILE"

http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.4.0/22
EOF
          fi
        fi
      '';
    };
  };

  # Podman Macvlan Network Setup on br0
  systemd.services.podman-macvlan-setup = {
    description = "Create Podman Macvlan network on br0";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "setup-podman-macvlan" ''
        if ! ${pkgs.podman}/bin/podman network exists br0_lan; then
          ${pkgs.podman}/bin/podman network create -d macvlan \
            -o parent=br0 \
            --subnet=${fleetSettings.network.subnet}/${toString fleetSettings.network.subnetPrefix} \
            --gateway=${fleetSettings.network.gateway} \
            br0_lan
        fi
      '';
    };
  };

  # Container Definition
  virtualisation.oci-containers.containers.homeassistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    environment = {
      TZ = "America/New_York";
    };
    volumes = [
      "${haConfigDir}:/config"
    ];
    extraOptions = [
      "--network=br0_lan"
      "--ip=${haIp}"
      "--dns=${builtins.head fleetSettings.network.dns}"
      # Map persistent USB Zigbee Dongle (adjust path if needed)
      "--device=/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_v2_20230508104532-if00-port0:/dev/ttyZigbee"
    ];
  };

  # Grant container access to serial hardware
  services.udev.extraRules = ''
    KERNEL=="ttyUSB*", MODE="0666"
    KERNEL=="ttyACM*", MODE="0666"
  '';
}
