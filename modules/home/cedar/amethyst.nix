{ pkgs, ... }:

let
  version = "2.0.3";
  # Download the file
  src = pkgs.fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/AmethystModManager-${version}-x86_64.AppImage";
    hash = "sha256-VAYIKPUbLE8M2h73caypRdyAXVlQ3GtvO+MpwPQpHIE=";
  };

  amethystIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ChrisDKN/Amethyst-Mod-Manager/main/src/icons/Logo.png";
    hash = "sha256-RonqF4Osw4nZgz6vYgH71Q8ozhU3WiUAURTnSnDfv0U=";
  };


  # Create a simple package that exposes the AppImage
  amethyst = pkgs.runCommand "amethyst-${version}" {
    buildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    cp ${src} $out/bin/amethyst-bin
    chmod +x $out/bin/amethyst-bin

    # Create a wrapper that allows it to execute
    makeWrapper $out/bin/amethyst-bin $out/bin/amethyst \
      --set APPIMAGE_EXTRACT_AND_RUN 1
  '';
in
{
  home.packages = [ amethyst ];

  xdg.desktopEntries.amethyst = {
    name = "Amethyst Mod Manager";
    exec = "amethyst";
    icon = amethystIcon;
    terminal = false;
    categories = [ "Game" ];
  };
}
