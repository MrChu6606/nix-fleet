{ fleetSettings, ... }: {
  services = {
    wyoming.whisper.servers."local-stt" = {
      enable = true;
      # Bind to all interfaces so Home Assistant or satellite satellites can reach it
      uri = "tcp://0.0.0.0:${fleetSettings.ports.whisper}";
      
      # Model size options: tiny, base, small, medium
      # "base" or "small" offers the best balance on a laptop CPU/GPU
      model = "small";
      language = "en";

      # Hardware Acceleration
      device = "cuda";
    };

    wyoming.piper.servers."local-tts" = {
      enable = true;
      uri = "tcp://0.0.0.0:${toString fleetSettings.ports.piper}";

      # Piper voices use the format "voice-quality"
      voice = "en_US-lessac-medium";
    };
  };

  networking.firewall.allowedTCPPorts = with fleetSettings.ports; 
  [ 
    whisper
    piper 
  ];
}
