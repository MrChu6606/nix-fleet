{ pkgs, ... }: let
  stable = with pkgs; [
    wget
    git
    fastfetch
    curl
    neovim
    yazi
  ];
in {
  environment.systemPackages = stable;
}
