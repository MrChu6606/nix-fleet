{ pkgs, ... }: let
  stable = with pkgs; [
    wget
    git
    fastfetch
    curl
    neovim
    yazi
    wl-clipboard
  ];
in {
  environment.systemPackages = stable;
}
