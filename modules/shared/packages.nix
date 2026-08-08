{ pkgs, ... }: let
  stable = with pkgs; [
    wget
    tmux
    git
    fastfetch
    curl
    yazi
    wl-clipboard
    sops
    age
    tree
    usbutils
    iftop
    btop
  ];
in {
  environment.systemPackages = stable;
}
