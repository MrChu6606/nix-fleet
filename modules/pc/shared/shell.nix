_: {
  programs.zsh.interactiveShellInit = ''
    source $HOME/nix-fleet/shell/aliases.sh
  '';

  programs.nh = {
    enable = true;
    clean.enable = true;

    flake = "/home/nic/nix-fleet/";
  };
}
