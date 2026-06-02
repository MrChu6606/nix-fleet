{ pkgs, ... }: 
let
  lithium = pkgs.fetchurl {
    name = "lithium-0.11.4";
    url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/iEcXOkz4/lithium-fabric-mc1.20.1-0.11.4.jar";
    sha256 = "sha256-dhM+/pKuqQfPdVYtniZRfesXDiWA4ezUl52iyJAt54I=";
  };

  ferritecore = pkgs.fetchurl {
    name = "ferritecore-6.0.1";
    url = "https://cdn.modrinth.com/data/uXXizFIs/versions/unerR5MN/ferritecore-6.0.1-fabric.jar";
    sha256 = "sha256-x7oRGKBbLakA0cNp++EBej4+w8r+XlE5i4USebm+zyQ=";
  };

  cc-tweaked = pkgs.fetchurl {
    name = "cc-tweaked-1.119.0";
    url = "https://cdn.modrinth.com/data/gu7yAYhd/versions/tRJJRQ5J/cc-tweaked-1.20.1-fabric-1.119.0.jar";
    sha256 = "sha256-sThmtsrUwkxPdwcByhw+sKyO9HNYLrv8NrmuDFg2ERc=";
  };

  mods = [ lithium ferritecore cc-tweaked ];
  modpack = pkgs.runCommand "mc-mods" {} ''
    mkdir -p $out
    ${pkgs.lib.concatMapStringsSep "\n" (mod: "ln -s ${mod} $out/${mod.name}") mods}
  '';
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
            "${modpack}:/data/mods"
          ];

          environment = {
            EULA = "TRUE";
            TYPE = "FABRIC";
            VERSION = "1.20.1";
            MEMORY = "8G";
            # Aikars flags for jvm tuning
            JVM_OPTS = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8m -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";
          };

          restart = "unless-stopped";
        };
      };
    };
  };
}
