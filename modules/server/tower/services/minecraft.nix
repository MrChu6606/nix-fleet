{ pkgs, ... }: 
let
  mods = [
    (pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/gvQ6tQ3v/versions/1.3.1/lithium.jar";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    })

    (pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/0.4.10/ferritecore.jar";
      sha256 = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
    })

    (pkgs.fetchurl {
      url = "https://cdn.modrinth.com/data/gu7yAYhd/versions/tRJJRQ5J/cc-tweaked-1.20.1-fabric-1.119.0.jar";
      sha256 = "sha256-CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC=";
    })
  ];

  modpack = pkgs.runCommand "mc-mods" {} ''
    mkdir -p $out/mods
    cp ${pkgs.lib.concatStringsSep " " mods} $out/mods
  '';
in
{
  virtualisation.arion.projects.minecraft.settings = {
    project.name = "minecraft";

    services.minecraft = {
      service = {
        image = "itzg/minecraft-server:latest";

        ports = [ "25565:25565" ];

        volumes = [
          "/appdata/minecraft/data:/data"

          # inject mods from Nix
          "${modpack}/mods:/data/mods"
        ];

        environment = {
          EULA = "TRUE";
          TYPE = "FABRIC";
          VERSION = "1.21.5";
          MEMORY = "4G";
        };

        extraOptions = [
          "--restart=unless-stopped"
        ];
      };
    };
  };
}
