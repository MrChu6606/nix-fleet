{ fleetSettings, config, lib, ... }:
let 
  host = config.networking.hostName;
  hostConfig = fleetSettings.hosts.${host};
  hasWifi = hostConfig ? wifi && hostConfig.wifi != null;
in {
  # Force exclusive systemd-networkd control to prevent IP collisions
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  # Backend Wireless Configuration
  networking.wireless.iwd = {
    enable = true;
    settings.Network = {
      EnableIPv6 = false;
      RoutePriorityOffset = 300; 
    };
  };

  # Interface Management
  systemd = {
    network = {
      enable = true;
      networks = {
        # Wired Ethernet - Always Static
        "10-ethernet-static" = {
          matchConfig.Name = "en* eth* end*";
          networkConfig = {
            Address = [ "${hostConfig.lan}/${toString fleetSettings.network.subnetPrefix}" ];
            Gateway = fleetSettings.network.gateway;
            DNS = fleetSettings.network.dns;
          };
        };

        # Wireless - Conditional on host config having a wifi entry
        "20-wireless-static" = lib.mkIf hasWifi {
          matchConfig.Name = "wl* wlan*";
          networkConfig = {
            Address = [ "${hostConfig.wifi}/${toString fleetSettings.network.subnetPrefix}" ];
            Gateway = fleetSettings.network.gateway;
            DNS = fleetSettings.network.dns;
            IgnoreCarrierLoss = "3s";
          };
        };
      };
    };
    services.systemd-networkd-wait-online = {
      # Tell it to succeed as long as at least ONE interface is online
      serviceConfig.ExecStart = [
        "" # This clears the default arguments
        "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
      ];
    };
  };

  # Wireless Provisioning
  systemd.services."iwd-config" = {
    description = "Provision Wi-Fi network credentials";
    wantedBy = [ "multi-user.target" ];
    before = [ "iwd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      mkdir -p /var/lib/iwd
      chmod 700 /var/lib/iwd
      cat << 'EOF' > "/var/lib/iwd/CHANGE.psk"
      [Security]
      Passphrase=CHANGE
      EOF
      chmod 600 "/var/lib/iwd/CHANGE.psk"
    '';
  };
}
