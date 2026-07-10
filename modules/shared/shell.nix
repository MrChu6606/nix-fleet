{
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;

    promptInit = ''
      autoload -U promptinit; promptinit
      prompt pure
    '';
  };

  environment.systemPackages = with pkgs; [
    pure-prompt
    usbutils
    iftop
    btop
  ];
}
