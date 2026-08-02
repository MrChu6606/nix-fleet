{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "tide-island";
  version = "unstable-2026";

  src = pkgs.fetchFromGitHub {
    owner = "enhaoswen";
    repo = "Tide-island";
    rev = "main"; # Or pin to a specific commit/tag
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Replace with actual hash
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = with pkgs; [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qt5compat
    qt6.qtconnectivity
    quickshell
    wireplumber
    brightnessctl
  ];

  # Ensures runtime binaries like quickshell, brightnessctl, gammastep are accessible
  qtWrapperArgs = [
    "--prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
      quickshell
      brightnessctl
      wireplumber
      gammastep
      cava
      awww
    ])}"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/tide-island
    cp -r * $out/share/tide-island/
    
    # Create wrapper executable if tide-island uses quickshell entrypoint
    makeWrapper ${pkgs.quickshell}/bin/quickshell $out/bin/tide-island \
      --add-flags "-p $out/share/tide-island" \
      "''${qtWrapperArgs[@]}"
    runHook postInstall
  '';
}
