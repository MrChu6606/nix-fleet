{ config, fleetSettings, ... }: {
  sops.secrets."librechat_env" = {
    sopsFile = ../../../secrets/laptop.yaml;
    format = "yaml";
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
      OLLAMA_API_BASE_URL = "http://host.containers.internal:${toString fleetSettings.ports.ollama}";
    };

    extraOptions = [
      "--add-host=host.containers.internal:host-gateway"
    ];

    volumes = [
      "/var/lib/librechat/public/images:/app/client/public/images"
      "/var/lib/librechat/data:/app/api/data"
    ];

    autoStart = true;
  };

  systemd.services.podman-librechat.preStart = ''
    mkdir -p /var/lib/librechat/data
    mkdir -p /var/lib/librechat/public/images
  '';

  networking.firewall.allowedTCPPorts = [
    fleetSettings.ports.librechat
  ];
}
