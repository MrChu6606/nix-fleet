{
  pkgs,
  unstablePkgs,
  nvfPkg,
  zenPkg,
  ...
}: let
  stable = with pkgs; [
    wget
    git
    rclone
    ripgrep
    tor-browser
    qutebrowser
    mpv
    yt-dlp
    streamlink
    usbutils
    fastfetch
    alacritty
    cmatrix
    cbonsai
    gnumake
    curl
    pastel
    imv
    numix-cursor-theme
    exiftool
    dunst
    evtest
    tealdeer
    tree
    wireshark
    btop
    zathura
    dig
    prismlauncher
    unzip
    zip
    vscode
    neovim
    wl-clipboard
    pavucontrol
    brightnessctl
    kanshi
    vesktop
    ffmpeg
    xdg-utils
    localsend
    #pdf stuff
    file
    clamav
    poppler-utils
    kdePackages.okular
    zathura
    #school
    zoom-us
    flameshot
    grim
    imagemagick
    qalculate-qt
    fd
    # games
    vitetris
    moon-buggy
  ];

  unstable = with unstablePkgs; [
    openjdk17
    python3
    lua
    luajit
    gcc
    tree-sitter
    yazi
    noctalia-shell
  ];
in {
  environment.systemPackages = stable ++ unstable ++ [nvfPkg zenPkg];

  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      "org.vinegarhq.Sober"
    ];
  };
}
