{ fleetSettings, ... }: {
  virtualisation.oci-containers.containers.librechat = {
    image = "ghcr.io/danny-avila/librechat:latest";
    extraOptions = [ "--network=host" ]; # Allows connecting directly to host 127.0.0.1:11434

    environment = {
      HOST = "0.0.0.0";
      PORT = toString fleetSettings.ports.librechat;
      OLLAMA_API_BASE_URL = "http://127.0.0.1:${toString fleetSettings.ports.ollama}";
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
