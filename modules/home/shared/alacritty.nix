_: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        dynamic_title = true;
        opacity = 0.91;
        padding = { 
          x = 10; 
          y = 10; 
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 5;
      };

      font = {
        size = 12.5;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };

      cursor.style = "Beam";
    };
  };
}
