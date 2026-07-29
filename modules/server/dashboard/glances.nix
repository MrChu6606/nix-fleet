{ pkgs, fleetSettings, ... }: {
  environment.systemPackages = with pkgs; [
    glances
    wlr-randr # Display output manager for Wayland compositors
    vcgencmd  # Raspberry Pi firmware interface (optional hardware controls)
  ];

  # Systemd service to run Glances web server on boot
  systemd.services.glances = {
    description = "Glances Web Dashboard";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.glances}/bin/glances -w --bind 0.0.0.0 --port ${fleetSettings.ports.glances}";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
