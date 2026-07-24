{ fleetSettings, ... }: {
  virtualisation.oci-containers.containers.librechat = {
    image = "ghcr.io/danny-avila/librechat:latest";

    ports = [
      "${toString fleetSettings.ports.librechat}:3080"
    ];

    environment = {
      HOST = "0.0.0.0";

      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };

    volumes = [
      "/var/lib/librechat:/app/client/public/images"
      "/var/lib/librechat/data:/app/api/data"
    ];

    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [
    fleetSettings.ports.librechat
  ];
}
