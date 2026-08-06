{ pkgs, nvfFN, zenPkg, ... }: let
  stable = with pkgs; [
    rclone
    ripgrep
    numix-cursor-theme # cursor
    tealdeer # tldr tool
    zathura # terminal pdf viewer
    prismlauncher # minecraft
    unzip
    zip
    vscode # ide
    pavucontrol # audio
    brightnessctl # brightness
    vesktop # discord
    tailspin # log highlighter
  ];

  unstable = with pkgs.unstable; [
    yazi # file manager
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
  };
}
