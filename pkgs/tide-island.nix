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
    qt6.qtwayland
    quickshell
  ];

  dontWrapQtApps = true;

  postInstall = ''
    mkdir -p $out/share/tide-island
    cp -rn $src/* $out/share/tide-island/ || true

    if [ -d "$out/lib/qt6/qml/IslandBackend" ]; then
      ln -s $out/lib/qt6/qml/IslandBackend $out/share/tide-island/IslandBackend
    fi
    if [ -d "$out/lib/qt6/qml/TideIsland" ]; then
      ln -s $out/lib/qt6/qml/TideIsland $out/share/tide-island/TideIsland
    fi

    # Stub lyricsmpris binary so warnings disappear
    mkdir -p $out/bin
    echo '#!/bin/sh' > $out/bin/lyricsmpris
    echo 'exit 0' >> $out/bin/lyricsmpris
    chmod +x $out/bin/lyricsmpris

    # Shared QML import paths
    QML_PATHS="$out/lib/qt6/qml:$out/share/tide-island:${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtsvg}/lib/qt-6/qml:${pkgs.qt6.qtwayland}/lib/qt-6/qml"

    # Wrap main tide-island launcher
    makeWrapper ${pkgs.quickshell}/bin/quickshell $out/bin/tide-island \
      --add-flags "-p $out/share/tide-island" \
      --set QT_QPA_PLATFORM wayland \
      --prefix QML2_IMPORT_PATH : "$QML_PATHS" \
      --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtdeclarative}/lib/qt-6/plugins" \
      --prefix QUICKSHELL_IMPORT_PATH : "$out/lib/qt6/qml" \
      --prefix QUICKSHELL_IMPORT_PATH : "$out/share/tide-island" \
      --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
        quickshell
        brightnessctl
        wireplumber
        gammastep
        cava
        awww
        playerctl
        upower
        bluez
        procps
        jq
      ])}

    # Wrap tide-island-config-app with required QML & Plugin paths
    if [ -f "$out/bin/tide-island-config-app" ]; then
      wrapProgram $out/bin/tide-island-config-app \
        --prefix QML2_IMPORT_PATH : "$QML_PATHS" \
        --prefix QT_PLUGIN_PATH : "${pkgs.qt6.qtdeclarative}/lib/qt-6/plugins"
    fi

    # Update .desktop launcher file to point directly to wrapped binary in $out/bin
    if [ -f "$out/share/applications/tide-island-config-app.desktop" ]; then
      substituteInPlace $out/share/applications/tide-island-config-app.desktop \
        --replace-fail "Exec=tide-island-config-app" "Exec=$out/bin/tide-island-config-app"
    fi
  '';
}
