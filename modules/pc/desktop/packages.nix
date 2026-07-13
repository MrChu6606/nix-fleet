{ pkgs, ... }: let
  stable = with pkgs; [
    wiremix # audio output tui
    noctalia-shell
  ];
in {
  environment.systemPackages = stable;
}
