{ pkgs, ... }: {
  programs.zsh = {
    enable = true;

    promptInit = ''
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };

  environment.systemPackages = with pkgs; [
    pure-prompt
  ];

  system.userActivationScripts.linkZsh = {
    text = ''
      ln -sfn "$HOME/nix-fleet/shell/zshrc" "$HOME/.zshrc"
      ln -sfn "$HOME/nix-fleet/aliases" "$HOME/.zsh_aliases"
    '';
  };
}
