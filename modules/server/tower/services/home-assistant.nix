{ pkgs, fleetSettings, ... }:
let
  haConfigDir = "/var/lib/homeassistant-config";
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
EOF
        chmod 644 "$CONFIG_FILE"
      '';
    };
  };

  # Container Definition
  systemd.services.podman-homeassistant = {
    after = [ "homeassistant-config-init.service" ];
    requires = [ "homeassistant-config-init.service" ];
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
      "--network=host"
    ];
  };

  services.udev.extraRules = ''
    KERNEL=="ttyUSB*", MODE="0666"
    KERNEL=="ttyACM*", MODE="0666"
  '';
}
