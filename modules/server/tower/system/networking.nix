{ pkgs, fleetSettings, ... }: {
  networking = {
    # Setup switch for managing containers
    bridges.br0.interfaces = [ "eno1" ];
    
    # Static bridge setup
    useDHCP = false;
    interfaces = {
      "br0" = {
        useDHCP = false;
        ipv4.addresses = [{
          address = fleetSettings.sequoia.lan;
          prefixLength = fleetSettings.network.subnetPrefix;
        }];
      };
    };

    defaultGateway = {
      address = fleetSettings.network.gateway;
      interface = "br0";
    };

    nameservers = fleetSettings.network.dns;

    # Firewall Protection for the Shim Interface
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -A INPUT -i macvlan-shim -m state --state ESTABLISHED,RELATED -j ACCEPT
        iptables -A INPUT -i macvlan-shim -m state --state NEW -j DROP
      '';
    };
  };

  # Declaratively create and manage the macvlan-shim interface link & route
  systemd.services.setup-macvlan-shim = {
    description = "Create host macvlan shim for container routing";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "macvlan-shim-up" ''
        if ! ${pkgs.iproute2}/bin/ip link show macvlan-shim >/dev/null 2>&1; then
          ${pkgs.iproute2}/bin/ip link add macvlan-shim link br0 type macvlan mode bridge
        fi
        ${pkgs.iproute2}/bin/ip link set macvlan-shim up
        ${pkgs.iproute2}/bin/ip addr add ${fleetSettings.sequoia.shim}/${toString fleetSettings.network.subnetPrefix} dev macvlan-shim 2>/dev/null || true
        ${pkgs.iproute2}/bin/ip route replace ${fleetSettings.sequoia.containers.homeassistant}/32 dev macvlan-shim || true
      '';
    };
  };
}
