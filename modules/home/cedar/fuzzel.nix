{ pkgs, ... }:{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.alacritty}/bin/alacritty -e";
        layer = "overlay";
        width = 35;
        font = "monospace:size=11";
      };
      colors = {
        background = "1e1e2eff";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        border = "b4befeef";
      };
      border = {
        width = 2;
        radius = 10;
      };
    };
  };
}
