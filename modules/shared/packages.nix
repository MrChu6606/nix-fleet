{ pkgs, ... }: let
  stable = with pkgs; [
    wget
    git
    fastfetch
    curl
    yazi
    wl-clipboard
    sops
    age
    tree
  ];
in {
  environment.systemPackages = stable;
}
