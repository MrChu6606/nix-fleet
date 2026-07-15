{ pkgs, ... }:

let
  # Define the packaged Amethyst AppImage
  amethyst = pkgs.appimageTools.wrapType2 rec {
    pname = "amethyst";
    version = "2.0.2";

    src = pkgs.fetchurl {
      url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/Amethyst_Mod_Manager-x86_64.AppImage";
      hash = "sha256-4Oclm72Z7wW2YJ502r3hU5K7r6R5g9Gg56E8P5T0u6k="; 
    };

    extraPkgs = pkgs: with pkgs; [ 
      webkitgtk_4_1
      openssl
    ];
  };
in
{
  # Add the wrapped package to your user profile
  home.packages = [ amethyst ];

  # Declaratively define the desktop entry for Niri
  xdg.desktopEntries.amethyst = {
    name = "Amethyst Mod Manager";
    genericName = "Mod Manager";
    comment = "Native Linux Mod Manager for Bethesda games and Cyberpunk 2077";
    exec = "${amethyst}/bin/amethyst";
    icon = "amethyst"; # Uses the app's default icon once wrapped
    terminal = false;
    categories = [ "Game" ];
    mimeType = [ "x-scheme-handler/nxm" ]; # Allows Nexus "Mod Manager Download" links to work
  };
}
