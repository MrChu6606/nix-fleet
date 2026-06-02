{ pkgs, ... }: let
  stable = with pkgs; [
    wget
    git
    fastfetch
    curl
    neovim
    yazi
    wl-clipboard
    sops
    age
    arion
  ];
in {
  environment.systemPackages = stable;
}
