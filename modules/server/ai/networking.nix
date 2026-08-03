{ fleetSettings, networkSettings, config, lib, ... }:
let 
  subnetPrefix = toString networkSettings.subnetPrefix;
  hasWifi = fleetSettings ? wifi && fleetSettings.wifi != null;
in {
  # Force exclusive systemd-networkd control on Pis
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  # Backend Wireless Configuration via iwd
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
        # Wired Ethernet - Primary interface
        "10-ethernet-static" = {
          matchConfig.Name = "en* eth* end*";
          networkConfig = {
            Address = [ "${fleetSettings.lan}/${subnetPrefix}" ];
            Gateway = networkSettings.gateway;
            DNS = networkSettings.dns;
          };
        };

        # Wireless Interface
        "20-wireless-static" = lib.mkIf hasWifi {
          matchConfig.Name = "wl* wlan*";
          networkConfig = {
            Address = [ "${fleetSettings.wifi}/${subnetPrefix}" ];
            Gateway = networkSettings.gateway;
            DNS = networkSettings.dns;
            IgnoreCarrierLoss = "3s";
          };
        };
      };
    };

    services.systemd-networkd-wait-online = {
      # Allow system boot as long as at least ONE interface connects
      serviceConfig.ExecStart = [
        "" # Clear default binary arguments
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
