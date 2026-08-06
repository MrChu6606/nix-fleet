{ loadModules, ... }:
{
  imports = loadModules ./.;

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
