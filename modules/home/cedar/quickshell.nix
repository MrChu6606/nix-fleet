{ pkgs, ... }: {
  home.packages = [ pkgs.quickshell ];

  xdg.configFile = {
    # Symlink shell.qml from dotfiles
    "quickshell/shell.qml".source = ../../../dotfiles/quickshell/shell.qml;

    # Provide fallback ThemeColors.qml if Matugen hasn't generated one yet
    "quickshell/ThemeColors.qml" = {
      source = ../../../dotfiles/quickshell/ThemeColors.qml;
      # Prevent Home Manager from overwriting Matugen's live changes on rebuild
      force = false;
    };
  };

  # Systemd service to autostart Quickshell
  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell Dynamic Bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
