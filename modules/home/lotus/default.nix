_:
{
  imports = [
    ./alacritty.nix
    ./emacs.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = "nic";
    homeDirectory = "/home/nic";
    stateVersion = "26.05";
  };


  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "MrChu6606";
        email = "nmcicchi@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
