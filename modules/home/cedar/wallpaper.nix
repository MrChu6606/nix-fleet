{ pkgs, ... }: {
  home.packages = with pkgs; [
    waypaper
    matugen
  ];

  xdg.configFile = {
    "waypaper/config.ini".source = ../../../dotfiles/waypaper/config.ini;

    # Symlink Matugen configuration and templates from your dots directory
    "matugen/config.toml".source = ../../../dotfiles/matugen/config.toml;
    "matugen/templates".source = ../../../dotfiles/matugen/templates;
  };
}
