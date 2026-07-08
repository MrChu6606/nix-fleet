{ config, ... }: {
  programs.yazi.enable = true;

  # Create the config file telling termfilechooser to run our wrapper script
  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${config.home.homeDirectory}/.config/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME
  '';

  # Create the wrapper script that translates portal logic into Yazi commands
  xdg.configFile."xdg-desktop-portal-termfilechooser/yazi-wrapper.sh" = {
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
}
