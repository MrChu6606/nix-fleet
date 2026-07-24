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
        prepend_rules = [
          { mime = "application/pdf"; use = [ "zathura" "okular" ]; }
          { url = "*.pdf"; use = [ "zathura" "okular" ]; }
        ];
      };
    };
  };
}
