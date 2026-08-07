{ pkgs, fleetSettings, ... }:
let
  haIp = fleetSettings.sequoia.containers.homeassistant;
  haConfigDir = "/var/lib/homeassistant-config";
  shimIp = fleetSettings.sequoia.shim;
in
{
  virtualisation.oci-containers.backend = "podman";

  systemd.tmpfiles.rules = [
    "d ${haConfigDir} 0755 root root -"
  ];

  # Declaratively overwrite configuration.yaml with standard ASCII spaces and clean YAML structure
  systemd.services.homeassistant-config-init = {
    description = "Initialize Home Assistant configuration.yaml with reverse proxy settings";
    before = [ "podman-homeassistant.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "init-ha-config" ''
        CONFIG_FILE="${haConfigDir}/configuration.yaml"
        
        # Overwrite file to remove non-breaking spaces, duplicate keys, or malformed sections
        cat <<EOF > "$CONFIG_FILE"
# Home Assistant Configuration
default_config:

http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.4.0/22
    - ${fleetSettings.sequoia.lan}
    - ${shimIp}
EOF
        chmod 644 "$CONFIG_FILE"
      '';
    };
  };

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
  systemd.services.podman-homeassistant = {
    after = [ "setup-macvlan-shim.service" "podman-macvlan-setup.service" "homeassistant-config-init.service" ];
    requires = [ "setup-macvlan-shim.service" "podman-macvlan-setup.service" "homeassistant-config-init.service" ];
  };

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
    ];
  };

  services.udev.extraRules = ''
    KERNEL=="ttyUSB*", MODE="0666"
    KERNEL=="ttyACM*", MODE="0666"
  '';
}
