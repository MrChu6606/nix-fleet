_:{
  gtk = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 10;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk"; # Forces Qt apps to read GTK font/theme settings
    style.name = "adwaita-dark";
  };
}
