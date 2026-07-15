{ pkgs, ... }:

let
  version = "2.0.3";
  
  amethystSrc = pkgs.fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/AmethystModManager-${version}-x86_64.AppImage";
    hash = "sha256-VAYIKPUbLE8M2h73caypRdyAXVlQ3GtvO+MpwPQpHIE=";
  };

  # Use appimageTools to wrap the AppImage
  amethyst = pkgs.appimageTools.wrapType2 {
    name = "amethyst";
    src = amethystSrc;
    # Add any extra libraries required by the app here if it fails to launch
    extraPkgs = pkgs: with pkgs; [ ];
  };
in
{
  home.packages = [ amethyst ];

  xdg.desktopEntries.amethyst = {
    name = "Amethyst Mod Manager";
    # Point directly to the wrapped binary
    exec = "${amethyst}/bin/amethyst";
    icon = "amethyst"; # Ensure you manage the icon via home.file or copy it
    terminal = false;
    categories = [ "Game" ];
  };
}
