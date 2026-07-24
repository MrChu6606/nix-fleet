{ fleetSettings, pkgs, ... }:

{
  services.ollama = {
    enable = true;

    acceleration = "cuda";

    host = "0.0.0.0";
    port = fleetSettings.ports.ollama;

    # Preload commonly used models
    loadModels = [
      "qwen3:8b"
      "gemma3:4b"
    ];
  };

  # CUDA tools
  environment.systemPackages = with pkgs; [
    ollama
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
  ];

  networking.firewall.allowedTCPPorts = [
    fleetSettings.ports.ollama
  ];
}
