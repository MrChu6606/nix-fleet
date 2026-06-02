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
  ];
in {
  environment.systemPackages = stable;
}
