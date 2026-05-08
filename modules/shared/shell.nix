{
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;

    interactiveShellInit = ''
      source $HOME/nixOS-desktop/shell/aliases.sh
    '';

    promptInit = ''
      autoload -U promptinit; promptinit
      prompt pure
    '';

    ohMyZsh = {
      enable = false;
      plugins = [
        "sudo"
        "extract"
        "history-substring-search"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    pure-prompt
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;

    # This doesnt seem to work right now
    flake = "/home/nic/nixOS-desktop/";
  };
}
