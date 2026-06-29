{ loadModules, ... }:
{
  # This configures the Home Manager NixOS module itself
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true; 
    
    users.nic = {
      # This pulls in any other .nix files in this directory
      imports = loadModules ./.;

      home = {
        username = "nic";
        homeDirectory = "/home/nic";
        stateVersion = "26.05"; # Crucial to prevent HM warnings
      };

      programs.home-manager.enable = true;

      programs.git = {
        enable = true;
        userName = "MrChu6606";
        userEmail = "nmcicchi@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
        };
      };
    };
  };
}
