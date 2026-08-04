{ fleetSettings, ... }: {
  services = {
    wyoming.faster-whisper.servers."local-stt" = {
      enable = true;
      uri = "tcp://0.0.0.0:${toString fleetSettings.ports.whisper}";
      
      model = "small";
      language = "en";

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
