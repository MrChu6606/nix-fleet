{ lib, config, pkgs, ... }: {
  programs.niri.settings = {
    input.keyboard.xkb.options = "caps:swapescape,altwin:swap_alt_win";
    window-rules = lib.mkAfter [
      {
        matches = [
          { app-id = "^marvelrivals\\.exe$"; }
          { app-id = "^steam_app_2767030$"; }
          { title = "^Marvel Rivals"; }
        ];

        open-fullscreen = true;
        clip-to-geometry = true;
      }
    ];

    # Replace Noctalia auto-start with Tide Island
    spawn-at-startup = lib.mkForce [
      { command = [ "systemctl" "--user" "start" "quickshell" ]; }
    ];

    # Override Noctalia keybindings with Fuzzel, Swaylock, and Tide Island IPC
    binds = {
      "Mod+R" = {
        hotkey-overlay.title = "Open launcher: Fuzzel";
        action.spawn = [ "fuzzel" ];
      };

      "Mod+S" = {
        hotkey-overlay.title = "Control Center";
        action.spawn = [ "quickshell" "ipc" "call" "bar" "toggleControlCenter" ];
      };

      "Mod+N" = {
        hotkey-overlay.title = "Toggle Notification Center";
        action.spawn = [ "quickshell" "ipc" "call" "bar" "toggleNotificationCenter" ];
      };

      "Mod+Alt+L" = {
        hotkey-overlay.title = "Lock screen";
        action.spawn = [ "swaylock" ];
      };
    };

    layout = {
      struts = {
        top = 7;
      };
    };
  };

  # Strip `noctalia.kdl` from the KDL Configuration Output
  xdg.configFile.niri-config = lib.mkForce {
    target = "niri/config.kdl";
    source = pkgs.writeText "niri-config.kdl" ''
      ${config.programs.niri.finalConfig}
    '';
  };
}
