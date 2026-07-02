{
  pkgs,
  nvfFN,
  zenPkg,
  ...
}: let
  stable = with pkgs; [
    git
    sops
    rclone
    ripgrep
    curl 
    fastfetch # system fetcher
    numix-cursor-theme # cursor
    tealdeer # tldr tool
    zathura # terminal pdf viewer
    prismlauncher # minecraft
    unzip
    zip
    vscode # ide
    neovim # text editor
    wl-clipboard # clipboard for wayland
    pavucontrol # audio
    brightnessctl # brightness
    vesktop # discord
  ];

  unstable = with pkgs.unstable; [
    yazi # file manager
  ];
  
  nvfPkg = nvfFN pkgs.unstable;
in {
  environment.systemPackages = stable ++ unstable ++ [ nvfPkg zenPkg ];

  xdg.portal.enable = true;
  services.flatpak = {
    enable = true;

    remotes = [
      {
        name = "flathub";
        location = "https://f;athub.org/repo/flathub.flatpakrepo";
      }
    ];
  };
}
