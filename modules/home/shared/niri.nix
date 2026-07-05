{ config, ... }: {
  programs.niri.enable = true;

  programs.niri.settings = {
    # Only the input tweaks you actually changed
    input = {
      keyboard.xkb.options = "caps:swapescape";
      touchpad.natural-scroll = {};
      focus-follows-mouse.max-scroll-amount = "0%";
    };

    # Your custom styling preferences
    layout = {
      gaps = 12;
      focus-ring = {
        width = 4;
        active-color = "#d97742";
      };
      shadow = {
        softness = 30;
        spread = 5;
        offset = { x = 0; y = 5; };
        color = "#0007";
      };
    };

    cursor = {
      xcursor-theme = "Numix-Cursor";
      xcursor-size = 28;
    };

    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];

    hotkey-overlay.skip-at-startup = {};
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    # Your application-specific window overrides
    window-rules = [
      {
        matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
        default-column-width = {};
      }
      {
        matches = [ { app-id = "firefox$"; title = "^Picture-in-Picture$"; } ];
        open-floating = true;
      }
    ];

    # Only your custom keybinds and hardware hooks
    binds = with config.lib.niri; {
      # Custom Application & Shell Launchers
      "Mod+Return" = { hotkey-overlay-title = "Open a Terminal: alacritty"; action.spawn = [ "alacritty" ]; };
      "Mod+Q" = { hotkey-overlay-title = "Open browser: qutebrowser"; action.spawn = [ "qutebrowser" ]; };
      "Mod+P" = { hotkey-overlay-title = "Open browser: Zen"; action.spawn = [ "zen" ]; };
      "Mod+E" = { hotkey-overlay-title = "Open file manager: Yazi"; action.spawn = [ "sh" "-c" "alacritty -e yazi" ]; };
      "Mod+Shift+E" = { hotkey-overlay-title = "Open task manager: Kairo"; action.spawn = [ "sh" "-c" "alacritty -e kairo" ]; };
      "Mod+R" = { hotkey-overlay-title = "Open launcher"; action.spawn = [ "sh" "-c" "noctalia-shell ipc call launcher toggle" ]; };
      "Mod+S" = { hotkey-overlay-title = "Open control center"; action.spawn = [ "sh" "-c" "noctalia-shell ipc call controlCenter toggle" ]; };

      # Audio, Media & Brightness Controls
      "XF86AudioRaiseVolume" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0" ]; };
      "XF86AudioLowerVolume" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-" ]; };
      "XF86AudioMute" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ]; };
      "XF86AudioMicMute" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ]; };
      
      "XF86AudioPlay" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "playerctl play-pause" ]; };
      "XF86AudioStop" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "playerctl stop" ]; };
      "XF86AudioPrev" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "playerctl previous" ]; };
      "XF86AudioNext" = { allow-when-locked = true; action.spawn = [ "sh" "-c" "playerctl next" ]; };

      "XF86MonBrightnessUp" = { allow-when-locked = true; action.spawn = [ "brightnessctl" "--class=backlight" "set" "+10%" ]; };
      "XF86MonBrightnessDown" = { allow-when-locked = true; action.spawn = [ "brightnessctl" "--class=backlight" "set" "10%-" ]; };
      "XF86PowerOff" = { action.spawn = [ "noctalia-shell" "ipc" "call" "lockScreen" "lock" ]; };
    };
  };
}
