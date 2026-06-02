{ pkgs, ... }: 
# This is a nightmare of a list of mods, im not certain the best way to clean it up
let
  mods20-1 = [
    # When adding new mods, use fake hash before getting real hash 
    # sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=

    # Sever only
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

    # Server and client
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

  mods26-1 = [
    # Sever only
    (pkgs.fetchurl {
      name = "ferritecore-9.0";
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar?mr_download_reason=standalone";
      sha256 = "sha256-ITlmxy7ZZ6zHOSvrKKhm+6MB/1a5l2wueAHC233mvyI=";
    })

    (pkgs.fetchurl {
      name = "chunky-1.5.3";
      url = "https://cdn.modrinth.com/data/fALzjamp/versions/4Eotm6ov/Chunky-Fabric-1.5.3.jar";
      sha256 = "sha256-7N/FWg9n8+xvQIUGh2FclBriJr2I9OBhiKeyaP09qUI=";
    })

    (pkgs.fetchurl {
      name = "servercore-1.5.17";
      url = "https://cdn.modrinth.com/data/4WWQxlQP/versions/2siue87F/servercore-fabric-1.5.17%2B26.1.2.jar";
      sha256 = "sha256-TIMlZiFdj/3NsWv3utkIoduZZo2YpDaWQ2apxNhL3cA=";
    })


  ];

  makeModpack = name: modlist: pkgs.runCommand name {} ''
    mkdir -p $out
    ${pkgs.lib.concatMapStringsSep "\n" (mod: "ln -s ${mod} $out/${mod.name}") modlist}
  '';

  modpack20-1 = makeModpack "mc-mods-1-20-1" mods20-1;
  modpack26-1 = makeModpack "mc-mods-26-1" mods26-1;

  aikarFlags = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8m -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";
 
in
{
  virtualisation.arion = {
    backend = "docker";
    projects.minecraft.settings = {
      project.name = "minecraft";

      # Defines custom bridge network to bind to nixOS bridge
      networks.mc-bridge = {
        driver = "macvlan";
        driver_opts = {
          parent = "br0"; # Binds container to bridge
        };
        ipam.config = [
          {
            subnet = "192.168.4.0/22";
            gateway = "192.168.4.1";
          }
        ];
      };

      # Main survival world
      services.minecraft = {
        service = {
          image = "itzg/minecraft-server:latest";
          
          networks.mc-bridge = {
            # gives the server its own ip on the bridge
            ipv4_address = "192.168.4.29"; 
          };

          volumes = [
            "/appdata/minecraft/data:/data"

            # inject mods from Nix
            "${modpack20-1}:/data/mods"
          ];

          environment = {
            EULA = "TRUE";
            TYPE = "FABRIC";
            VERSION = "1.20.1";
            MEMORY = "12G";
            # Aikars flags for jvm tuning
            JVM_OPTS = aikarFlags;

            ENABLE_AUTOPAUSE = "TRUE";
            # Disabled watchdog crash triggers for safe sleeping
            MAX_TICK_TIME = "-1"; 
            # Wait 5 min after last person leaves
            AUTPAUS_TIMEOUT_EST = "300";

            # View and simulation distance
            VIEW_DISTANCE = "16";
            SIMULATION_DISTANCE = "8";
          };

          restart = "unless-stopped";
        };
      };

      # Main survival world
      services.minecraft-latest = {
        service = {
          image = "itzg/minecraft-server:latest";
          
          networks.mc-bridge = {
            # gives the server its own ip on the bridge
            ipv4_address = "192.168.4.30"; 
          };

          volumes = [
            "/appdata/minecraft-latest/data:/data"

            # inject mods from Nix
            "${modpack26-1}:/data/mods"
          ];

          environment = {
            EULA = "TRUE";
            TYPE = "FABRIC";
            VERSION = "26.1.2";
            MEMORY = "10G";
            # Aikars flags for jvm tuning
            JVM_OPTS = aikarFlags;

            ENABLE_AUTOPAUSE = "TRUE";
            # Disabled watchdog crash triggers for safe sleeping
            MAX_TICK_TIME = "-1"; 
            # Wait 5 min after last person leaves
            AUTPAUS_TIMEOUT_EST = "300";
          };

          restart = "unless-stopped";
        };
      };

    };
  };
}
