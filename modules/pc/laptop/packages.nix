{
  pkgs,
  nvfFN,
  zenPkg,
  ...
}: let
  stable = with pkgs; [
    qutebrowser
    mpv # terminal video player
    yt-dlp # yt vid downloader
    streamlink # way to watch twitch ad free sorta
    gnumake
    imv
    exiftool # idk what this is
    evtest # or this
    tree # filesystem viewer thing
    wireshark # network traffic monitor
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
  ];

  nvfPkg = nvfFN pkgs.unstable;

in {
  environment.systemPackages = stable ++ unstable ++ [ nvfPkg zenPkg ];
}
