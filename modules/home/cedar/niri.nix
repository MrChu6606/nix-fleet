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

    # Auto-start Tide Island
    spawn-at-startup = lib.mkForce [
      { command  = [ "aww-daemon" ]; }
      { command = [ "tide-island" ]; }
    ];

    # Keybindings adjusted for Tide Island IPC
    binds = {
      "Mod+R" = {
        hotkey-overlay.title = "Open launcher: Fuzzel";
        action.spawn = [ "fuzzel" ];
      };

      "Mod+Alt+L" = {
        hotkey-overlay.title = "Lock screen";
        action.spawn = [ "swaylock" ];
      };

      # Island Toggle (Super+Shift+F original)
      "Mod+Shift+F" = lib.mkForce {
        hotkey-overlay.title = "Toggle Island";
        action.spawn = [ "tide-island" "ipc" "call" "island" "toggle" ];
      };

      # Control Center
      "Mod+S" = {
        hotkey-overlay.title = "Toggle Control Center";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "toggleControlCenter" ];
      };

      # Notifications
      "Mod+N" = {
        hotkey-overlay.title = "Toggle Notification Center";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "toggleNotificationCenter" ];
      };

      # Media Player
      "Mod+M" = {
        hotkey-overlay.title = "Toggle Media Player";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "togglePlayer" ];
      };

      # Clock Dropdown
      "Mod+Down" = {
        hotkey-overlay.title = "Show Clock";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "showClock" ];
      };

      # Wallpaper Picker (Super+W -> Mod+Shift+W, keeping Mod+W for column tabbed mode)
      "Mod+Shift+W" = {
        hotkey-overlay.title = "Toggle Wallpaper Picker";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "toggleWallpaperPicker" ];
      };

      # Application Launcher
      "Mod+Slash" = {
        hotkey-overlay.title = "Toggle Application Launcher";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "toggleApplicationLauncher" ];
      };

      # Gesture / Navigation Swipes
      "Mod+Left" = {
        hotkey-overlay.title = "Tide Island Swipe Left";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "swipeLeft" ];
      };
      "Mod+Right" = {
        hotkey-overlay.title = "Tide Island Swipe Right";
        action.spawn = [ "tide-island" "ipc" "call" "tide" "swipeRight" ];
      };
    };

    layout = {
      struts = {
        top = 0;
      };
    };
  };

  # Strip any leftover KDL inclusions (like noctalia.kdl) from output
  xdg.configFile.niri-config = lib.mkForce {
    target = "niri/config.kdl";
    source = pkgs.writeText "niri-config.kdl" ''
      ${config.programs.niri.finalConfig}
    '';
  };
}
