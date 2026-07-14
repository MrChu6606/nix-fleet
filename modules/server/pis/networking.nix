{ fleetSettings, config, lib, ... }:
let 
  host = config.networking.hostName; #[cite: 3]
  hostConfig = fleetSettings.hosts.${host} or null; #[cite: 3]
  isStatic = hostConfig != null; #[cite: 3]
  
  # Check if a specific Wi-Fi static IP is configured for this host
  hasWifiStatic = isStatic && (hostConfig ? wifi && hostConfig.wifi != null);
in {
  # Backend Wireless Configuration (iwd)
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Network = {
        EnableIPv6 = false;
        # Prioritize ethernet routing over Wi-Fi if both are active
        RoutePriorityOffset = 300; 
      };
    };
  };

  # Interface Management (systemd-networkd matching)
  systemd.network = {
    enable = true;
    networks = {
      # Wired Ethernet Profiles
      "10-ethernet-dhcp" = lib.mkIf (!isStatic) {
        matchConfig.Name = "en* eth* end*";
        networkConfig.DHCP = "ipv4";
      };
      "10-ethernet-static" = lib.mkIf isStatic {
        matchConfig.Name = "en* eth* end*";
        address = [ "${hostConfig.lan}/${toString fleetSettings.network.subnetPrefix}" ];
        gateway = [ fleetSettings.network.gateway ];
        dns = fleetSettings.network.dns;
      };

      # Wireless Profiles
      "20-wireless-dhcp" = lib.mkIf (!hasWifiStatic) {
        matchConfig.Name = "wl* wlan*";
        networkConfig.DHCP = "ipv4";
      };
      "20-wireless-static" = lib.mkIf hasWifiStatic {
        matchConfig.Name = "wl* wlan*";
        address = [ "${hostConfig.wifi}/${toString fleetSettings.network.subnetPrefix}" ];
        gateway = [ fleetSettings.network.gateway ];
        dns = fleetSettings.network.dns;
        networkConfig.IgnoreCarrierLoss = "3s";
      };
    };
  };

  # Dynamic Wi-Fi Credential Provisioning
  systemd.services."iwd-config" = {
    description = "Provision Wi-Fi network credentials";
    wantedBy = [ "multi-user.target" ];
    before = [ "iwd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    # CHANGE THIS TO SOPS OR SOME
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
