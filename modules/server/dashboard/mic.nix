{ pkgs, ... }: {
# Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Add some CLI tools to test the mic
  environment.systemPackages = with pkgs; [
    alsa-utils # Provides 'arecord' for testing
    pulseaudio # Provides 'parecord' for testing
  ];
}
