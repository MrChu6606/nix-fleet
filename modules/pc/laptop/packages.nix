{
  pkgs,
  nvfFN,
  zenPkg,
  ...
}: let
  stable = with pkgs; [
    wget
    git
    sops # for secrets
    rclone # for copy pasting large files across drives
    ripgrep
    tor-browser
    qutebrowser
    mpv # terminal video player
    yt-dlp # yt vid downloader
    streamlink # way to watch twitch ad free sorta
    fastfetch
    alacritty # terminal emulator
    cmatrix # flash ware
    cbonsai # flash ware
    gnumake
    curl
    pastel # for picking colors
    imv
    numix-cursor-theme
    exiftool # idk what this is
    evtest # or this
    tealdeer # man page helper
    tailspin # log highlighter
    tree # filesystem viewer thing
    wireshark # network traffic monitor
    zathura # pdf viewer
    dig
    prismlauncher # minecraft
    unzip
    zip
    vscode
    neovim
    wl-clipboard
    pavucontrol # audio
    brightnessctl # brightness
    kanshi # todo list
    vesktop # discord
    ffmpeg
    xdg-utils
    localsend # file transfer thing
    file # this isnt included by default?
    clamav # idk what this is
    poppler-utils
    kdePackages.okular # pdf editor
    zathura # terminal pdf viewer
    flameshot # screen shot tool (i hate it)
    grim # ss tool dependency
    imagemagick # actual magic
    qalculate-qt # calculator
    fd
    # games
    vitetris
    moon-buggy
    nmap
  ];

  unstable = with pkgs.unstable; [
    openjdk17
    python3
    lua
    luajit
    gcc
    tree-sitter
    yazi
    noctalia-shell
  ];

  nvfPkg = nvfFN pkgs.unstable;

in {
  environment.systemPackages = stable ++ unstable ++ [ nvfPkg zenPkg ];

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
