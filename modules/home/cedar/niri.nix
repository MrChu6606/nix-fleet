{ lib, ... }: {
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
  };
}
