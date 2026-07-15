{ pkgs, ... }:

let
  version = "2.0.3";
  # Define source with hash
  amethystSrc = pkgs.fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/AmethystModManager-${version}-x86_64.AppImage";
    hash = "sha256-VAYIKPUbLE8M2h73caypRdyAXVlQ3GtvO+MpwPQpHIE=";
  };

  amethystIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ChrisDKN/Amethyst-Mod-Manager/main/src/icons/Logo.png";
    hash = "sha256-RonqF4Osw4nZgz6vYgH71Q8ozhU3WiUAURTnSnDfv0U=";
  };

  # Create a derivation that installs the file
  amethyst = pkgs.stdenv.mkDerivation {
    inherit version;
    pname = "amethyst";
    src = amethystSrc;

    # No build phase needed, just install the file
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/amethyst
      chmod +x $out/bin/amethyst
    '';
  };
in
{
  # add to packages and use appimage-run for execution
  home.packages = [ amethyst ];

  xdg.desktopEntries.amethyst = {
  name = "Amethyst Mod Manager";
  genericName = "Mod Manager";
  comment = "Native Linux Mod Manager for Bethesda games and Cyberpunk 2077";
  # This points directly to the binary installed by your custom derivation
  exec = "${pkgs.appimage-run}/bin/appimage-run ${amethyst}/bin/amethyst";
  icon = "${amethystIcon}";
  terminal = false;
  categories = [ "Game" ];
  };
}
