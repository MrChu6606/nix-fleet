{ config, pkgs, fleetSettings, ... }: 
let
  mods20-1 = [
    (pkgs.fetchurl {
      name = "ferritecore-6.0.1";
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/unerR5MN/ferritecore-6.0.1-fabric.jar";
      sha256 = "sha256-x7oRGKBbLakA0cNp++EBej4+w8r+XlE5i4USebm+zyQ=";
    })
    (pkgs.fetchurl {
      name = "chunky-1.3.146";
      url = "https://cdn.modrinth.com/data/fALzjamp/versions/NHWYq9at/Chunky-1.3.146.jar";
      sha256 = "sha256-rn+501o6nZ1PIQSurnsxqQHF5YQokeLt2d3MQsJkajg=";
    })
    (pkgs.fetchurl {
      name = "servercore-1.5.2";
      url = "https://cdn.modrinth.com/data/4WWQxlQP/versions/m978FuzE/servercore-fabric-1.5.2%2B1.20.1.jar";
      sha256 = "sha256-0CJTq3Vm8qZjLMeMlwjddoz3esgSM1HtY74l5PjLMX8=";
    })
    (pkgs.fetchurl {
      name = "lithium-0.11.4";
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/iEcXOkz4/lithium-fabric-mc1.20.1-0.11.4.jar";
      sha256 = "sha256-dhM+/pKuqQfPdVYtniZRfesXDiWA4ezUl52iyJAt54I=";
    })
    (pkgs.fetchurl {
      name = "cc-tweaked-1.119.0";
      url = "https://cdn.modrinth.com/data/gu7yAYhd/versions/tRJJRQ5J/cc-tweaked-1.20.1-fabric-1.119.0.jar";
      sha256 = "sha256-sThmtsrUwkxPdwcByhw+sKyO9HNYLrv8NrmuDFg2ERc=";
    })
    (pkgs.fetchurl {
      name = "ccchunkloader-1.3.0";
      url = "https://cdn.modrinth.com/data/XcghFcon/versions/6Zb7NXJT/ccchunkloader-1.3.0.jar";
      sha256 = "sha256-rEcc6N5fqtqSr5SBAaWj6xd+r0vE3tMttFPkPCZ2zC4=";
    })
    (pkgs.fetchurl {
      name = "hexcasting-0.11.3";
      url = "https://cdn.modrinth.com/data/nTW3yKrm/versions/PqdeU0a7/hexcasting-fabric-1.20.1-0.11.3.jar";
      sha256 = "sha256-6/vQVVSBCeO9ja3UDhAsAF83jopuX90eZRkgekR75yY=";
    })
    (pkgs.fetchurl {
      name = "patchouli-1.20.1-85";
      url = "https://cdn.modrinth.com/data/nU0bVIaL/versions/nm6fiGRx/Patchouli-1.20.1-85-FABRIC.jar";
      sha256 = "sha256-SF4jq5cnx+n1hfQ1Ag1zNwaoDH8KHcIOhcc5jh12uRk=";
    })
    (pkgs.fetchurl {
      name = "cardinalcomponents-5.2.3";
      url = "https://cdn.modrinth.com/data/K01OU20C/versions/Ielhod3p/cardinal-components-api-5.2.3.jar";
      sha256 = "sha256-/x4zrd5Dw+AffppnPLt/OnVFPnafgKOLBXZTR14paqI=";
    })
    (pkgs.fetchurl {
      name = "clothconfig-11.1.136";
      url = "https://cdn.modrinth.com/data/9s6osm5g/versions/2xQdCMyG/cloth-config-11.1.136-fabric.jar";
      sha256 = "sha256-hE9JwznI8xROFnqyG30AWfDVcQVOJihaB0k0jaJcSfo=";
    })
    (pkgs.fetchurl {
      name = "fabricapi-0.92.9";
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/hu6gukgT/fabric-api-0.92.9%2B1.20.1.jar";
      sha256 = "sha256-QFaXnMqhASNU3/8U85/bCFrvs/HgIk/0XDr0Hk/+1f0=";
    })
    (pkgs.fetchurl {
      name = "fabriclangkotlin-1.13.11+kotlin.2.3.21";
      url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/2i87JpYj/fabric-language-kotlin-1.13.11%2Bkotlin.2.3.21.jar";
      sha256 = "sha256-w1cT7h2nD95r8OntJvjiuvCBTmDrmTzRKsuUDlf0/S8=";
    })
    (pkgs.fetchurl {
      name = "inline-1.2.2";
      url = "https://cdn.modrinth.com/data/fin1PX4m/versions/n7VmkBLu/inline-fabric-1.20.1-1.2.2.jar";
      sha256 = "sha256-sophnF5OvmnRuOtSlfYpSiC7DnjfsRYKAPcSGPWxZRg=";
    })
    (pkgs.fetchurl {
      name = "paucal-0.6.0";
      url = "https://cdn.modrinth.com/data/TZo2wHFe/versions/dabyDTwJ/paucal-0.6.0%2B1.20.1-fabric.jar";
      sha256 = "sha256-XM4iaux53VtwAGvfN0bmOfU9T2dLl/7DwGMFFeBw88c=";
    })
  ];

  makeModpack = name: modlist: pkgs.runCommand name {} ''
    mkdir -p $out
    ${pkgs.lib.concatMapStringsSep "\n" (mod: "ln -s ${mod} $out/${mod.name}") modlist}
  '';

  modpack20-1 = makeModpack "mc-mods-20-1" mods20-1;

  aikarFlags = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8m -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";
in
{
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  virtualisation.arion = {
    backend = "podman-socket";
    projects.minecraft-20.settings = {
      project.name = "minecraft-20";

      # Attach directly to the existing br0 host bridge
      networks.lan-bridge = {
        name = "lan-bridge";
        driver = "macvlan";
        driver_opts.parent = "br0";
        ipam.config = [{
          subnet = fleetSettings.network.subnet + "/${toString fleetSettings.network.subnetPrefix}";
          gateway = fleetSettings.network.gateway;
        }];
      };

      services.mc-ts = {
        service = {
          image = "tailscale/tailscale:latest";
          
          # Assign a dedicated, distinct IP for the Tailscale sidecar container
          networks.lan-bridge = {
            ipv4_address = fleetSettings.sequoia.containers.mc-20.router;
          };

          volumes = [
            "/var/lib/tailscale-mc-20:/var/lib/tailscale"
            "/dev/net/tun:/dev/net/tun"
            "${config.sops.secrets.tailscale_key.path}:/run/secrets/tailscale_key:ro"
          ];

          environment = {
            TS_AUTHKEY = "file:///run/secrets/tailscale_key";
            TS_STATEFUL_CONFIG = "true";
            TS_HOSTNAME = "mc-pool-box-20";
            # Subnet route advertising the Minecraft container's dedicated LAN IP into Tailscale
            TS_ROUTES = "${fleetSettings.sequoia.containers.mc-20.lan}/32";
          };
          capabilities = { NET_ADMIN = true; };

          sysctls = {
            "net.ipv4.ip_forward" = "1";
          };

          restart = "unless-stopped";
        };
      };

      services.minecraft = {
        service = {
          image = "itzg/minecraft-server:latest";
          
          # Container gets its dedicated LAN IP on br0
          networks.lan-bridge = {
            ipv4_address = fleetSettings.sequoia.containers.mc-20.lan;
          };

          volumes = [
            "/appdata/minecraft-20/data:/data"
            "${modpack20-1}:/data/mods"
          ];

          environment = {
            EULA = "TRUE";
            TYPE = "FABRIC";
            VERSION = "1.20.1";
            MEMORY = "12G";
            JVM_OPTS = aikarFlags;
            ENABLE_AUTOPAUSE = "TRUE";
            MAX_TICK_TIME = "-1"; 
            AUTPAUS_TIMEOUT_EST = "300";
            VIEW_DISTANCE = "16";
            SIMULATION_DISTANCE = "8";
            OPS = "MrChuwu";
            WHITELIST = "MrChuwu";
            ENFORCE_WHITELIST = "TRUE";
          };
          restart = "unless-stopped";
        };
      };
    };
  };

  systemd.services.arion-minecraft-20 = {
    after = [ "podman.socket" "podman.service" "network-online.target" ];
    wants = [ "podman.socket" "network-online.target" ];
    requires = [ "podman.socket" ];
    environment = {
      DOCKER_HOST = "unix:///run/podman/podman.sock";
    };
  };
}
