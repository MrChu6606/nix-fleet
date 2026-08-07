_: {
  programs.zsh.interactiveShellInit = ''
    eval $(direnv hook zsh)
  '';

  programs.nh = {
    enable = true;
    clean.enable = true;

    flake = "/home/nic/nix-fleet/";
  };
}
