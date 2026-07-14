{
  pkgs,
  nvfFN,
  zenPkg,
  ...
}: let
  stable = with pkgs; [
    wget
    qutebrowser
    mpv # terminal video player
    yt-dlp # yt vid downloader
    streamlink # way to watch twitch ad free sorta
    gnumake
    imv
    exiftool # idk what this is
    evtest # or this
    tailspin # log highlighter
    tree # filesystem viewer thing
    wireshark # network traffic monitor
    zathura # pdf viewer
    dig
    kanshi # todo list
    ffmpeg
    xdg-utils
    localsend # file transfer thing
    file # this isnt included by default?
    clamav # idk what this is
    poppler-utils
    kdePackages.okular # pdf editor
    flameshot # screen shot tool (i hate it)
    grim # ss tool dependency
    imagemagick # actual magic
    qalculate-qt # calculator
    fd
    nmap
    home-manager
  ];

  unstable = with pkgs.unstable; [
    openjdk17
    python3
    lua
    luajit
    gcc
    tree-sitter
    yazi
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
