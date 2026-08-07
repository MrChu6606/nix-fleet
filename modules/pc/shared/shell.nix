{ pkgs, ... }: {
  programs = {
    zsh.interactiveShellInit = ''
      eval "$(direnv hook zsh)"
    '';
    nh = {
      enable = true;
      clean.enable = true;

      flake = "/home/nic/nix-fleet/";
    };
    # Enables direnv
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableZshIntegration = true;
    };
  };

  environment.systemPackages = [ pkgs.devenv ];
}
