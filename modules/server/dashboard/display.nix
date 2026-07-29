_: {
  # Systemd services for controlling screen power
  systemd = {
    services = {
      display-off = {
        description = "Turn off dashboard screen";
        serviceConfig = {
          Type = "oneshot";
          # Runs wlr-randr or fallback to kernel console blanking if no Wayland server is active
          ExecStart = pkgs.writeShellScript "display-off" ''
            if [ -n "$WAYLAND_DISPLAY" ] || [ -S "/run/user/1000/wayland-0" ]; then
              WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --off
            else
              echo 1 > /sys/class/graphics/fb0/blank 2>/dev/null || true
            fi
          '';
        };
      };

      display-on = {
        description = "Turn on dashboard screen";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "display-on" ''
            if [ -n "$WAYLAND_DISPLAY" ] || [ -S "/run/user/1000/wayland-0" ]; then
              WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.wlr-randr}/bin/wlr-randr --output HDMI-A-1 --on
            else
              echo 0 > /sys/class/graphics/fb0/blank 2>/dev/null || true
            fi
          '';
        };
      };
    };

    # Schedule Timers for Bedtime / Wake-up
    # Turn OFF at 10:30 PM (22:30)
    timers = {
      display-off = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 22:30:00";
          Persistent = true;
        };
      };

      # Turn ON at 07:00 AM
      display-on = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 07:00:00";
          Persistent = true;
        };
      };
    };
  };
}
