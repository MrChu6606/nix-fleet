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
  ];
in {
  environment.systemPackages = stable;
}
