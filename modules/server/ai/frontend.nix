{ pkgs, config, fleetSettings, ... }: let
  yamlFormat = pkgs.formats.yaml { };

  configFile = yamlFormat.generate "librechat.yaml" {
    version = "1.1.5";
    endpoints = {
      custom = [
        {
          name = "Ollama";
          apiKey = "ollama"; # Required non-empty string for schema
          baseURL = "http://host.containers.internal:${toString fleetSettings.ports.ollama}/v1";
          models = {
            default = [ "qwen3:8b" "gemma3:4b" ];
            fetch = false;
          };
          titleConvo = true;
          showParams = true;
          dropParams = [ "user" ];
        }
      ];
    };
  };

in {
  sops.secrets."librechat_env" = {
    sopsFile = ../../../secrets/laptop.yaml;
    format = "yaml";
  };

  services.mongodb = {
    enable = true;
    bind_ip = "0.0.0.0";
    extraConfig = ''
      net.port: ${toString fleetSettings.ports.mongodb}
    '';
  };

  virtualisation.oci-containers.containers.librechat = {
    image = "ghcr.io/danny-avila/librechat:latest";

    ports = [
      "0.0.0.0:${toString fleetSettings.ports.librechat}:${toString fleetSettings.ports.librechat}"
    ];

    # Pass the decrypted env file directly to Podman[cite: 2]
    environmentFiles = [
      config.sops.secrets."librechat_env".path
    ];

    environment = {
      HOST = "0.0.0.0";
      PORT = toString fleetSettings.ports.librechat;
      MONGO_URI = "mongodb://host.containers.internal:${toString fleetSettings.ports.mongodb}/LibreChat";
    };

    extraOptions = [
      "--add-host=host.containers.internal:host-gateway"
    ];

    volumes = [
      "/var/lib/librechat/public/images:/app/client/public/images"
      "/var/lib/librechat/data:/app/api/data"
      "${configFile}:/app/librechat.yaml:ro"
    ];

    autoStart = true;
  };

  systemd.services.podman-librechat = {
    after = [ "mongodb.service" ];
    requires = [ "mongodb.service" ];
    preStart = ''
      mkdir -p /var/lib/librechat/data
      mkdir -p /var/lib/librechat/public/images
    '';
  };

  networking.firewall.allowedTCPPorts = with fleetSettings.ports; [
    librechat
    mongodb
  ];
}
