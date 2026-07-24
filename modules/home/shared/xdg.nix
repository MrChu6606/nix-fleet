{ config, ... }: {
  xdg = {
    # Set default xdg apps
    mimeApps = {
      enable = true;
      defaultApplications = {
        # set zathura as primary and okular as secondary
        "application/pdf" = [ 
          "org.pwmt.zathura.desktop"
          "org.kde.okular.desktop"
        ];
      };
    };

    # Termfilechooser configuration
    configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${config.home.homeDirectory}/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
    '';

    # Termfilechooser wrapper script
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

    # this is not working
    configFile."mimeapps.list".force = true;
  };
}
