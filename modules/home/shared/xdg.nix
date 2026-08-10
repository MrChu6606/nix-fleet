{ pkgs, config, ... }: {
  xdg = {
    enable = true;

    portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-termfilechooser
        pkgs.xdg-desktop-portal-gnome
      ];

      config = {
        niri = {
          default = ["termfilechooser" "gnome"];

          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
        };
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [
          "org.pwmt.zathura.desktop"
          "org.kde.okular.desktop"
        ];
      };
    };

    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${config.home.homeDirectory}/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
    '';

    configFile."xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh
        set -e
        multiple="$1"
        directory="$2"
        save="$3"
        path="$4"
        out="$5"

        termcmd="alacritty --class=file_chooser -e"
        cmd="yazi"

        if [ "$save" = "1" ]; then
          set -- --chooser-file="$out" "$path"
        elif [ "$directory" = "1" ]; then
          set -- --chooser-file="$out" "$path"
        else
          set -- --chooser-file="$out" "$path"
        fi

        exec $termcmd $cmd "$@"
      '';
    };

    configFile."mimeapps.list".force = true;
  };
}
