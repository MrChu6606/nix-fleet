_: {
  programs.yazi = {
    enable = true;
    settings = {
      opener = {
        zathura = [
          { run = ''zathura "$@"''; detach = true; desc = "Zathura"; }
        ];
        okular = [
          { run = ''okular "$@"''; detach = true; desc = "Okular"; }
        ];
      };

      open = {
        rules = [
          { mime = "application/pdf"; use = [ "zathura" "okular" ]; }
          { name = "*.pdf"; use = [ "zathura" "okular" ]; }
        ];
      };
    };
  };
}
