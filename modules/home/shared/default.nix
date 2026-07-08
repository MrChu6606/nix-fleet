_:
{
  imports = [
    ./alacritty.nix
    ./niri.nix
    ./yazi.nix
  ];
  programs.home-manager.enable = true;

  home = {
    username = "nic";
    homeDirectory = "/home/nic";
    stateVersion = "26.05";
  };

  xdg.configFile."alacritty/alacritty.toml" = {
    force = true;
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
