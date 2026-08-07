{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    cage
    chromium
  ];

  hardware.graphics.enable = true;

  systemd.services.ha-kiosk = {
    description = "Home Assistant Kiosk Display";
    after = [ "network.target" ];
    wantedBy = [ "graphical.target" ];

    serviceConfig = {
      Type = "simple";
      User = "nic";
      PAMName = "login";
      TTYPath = "/dev/tty7";
      TTYReset = true;
      TTYVHangup = true;
      StandardInput = "tty";
      StandardOutput = "tty";

      # Target the specific HA kiosk view with kiosk-mode query flag enabled
      ExecStart = ''
        ${pkgs.cage}/bin/cage -d -- ${pkgs.chromium}/bin/chromium \
          --kiosk \
          --no-first-run \
          --incognito \
          --disable-pinch \
          --overscroll-history-navigation=0 \
          "http://homeassistant.home/kiosk-dashboard/0?kiosk"
      '';

      Restart = "always";
      RestartSec = "5s";
    };
  };
}
