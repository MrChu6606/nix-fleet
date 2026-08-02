{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "tide-island";
  version = "unstable-2026";

  src = pkgs.fetchFromGitHub {
    owner = "enhaoswen";
    repo = "Tide-island";
    rev = "main";
    hash = "sha256-qh1iDBKWkk1dLWHf+Nemgr937i411HlaHAA1agM1A+8=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    python3
    qt6.wrapQtAppsHook
    makeBinaryWrapper
  ];

  buildInputs = with pkgs; [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qt5compat
    qt6.qtconnectivity
    quickshell
  ];

  # Force CMake to install QML modules and support files to $out/share/tide-island
  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share/tide-island"
  ];

  postInstall = ''
    # Copy source QML/JS assets into share directory if CMake install skips non-compiled QML files
    mkdir -p $out/share/tide-island
    cp -rn $src/* $out/share/tide-island/ || true

    # Ensure $out/bin exists and wrapper for tide-island launcher is created
    mkdir -p $out/bin
    makeWrapper ${pkgs.quickshell}/bin/quickshell $out/bin/tide-island \
      --add-flags "-p $out/share/tide-island" \
      --set QML2_IMPORT_PATH "$out/lib/qt-6/qml:$out/lib:$out/share/tide-island:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml" \
      --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
        quickshell
        brightnessctl
        wireplumber
        gammastep
        cava
        awww
      ])}
  '';
}
