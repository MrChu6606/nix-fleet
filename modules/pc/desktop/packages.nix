{ pkgs, ... }: let
  stable = with pkgs; [
    wiremix # audio output tui
    gdu # storage tui
  ];
in {
  environment.systemPackages = stable;
}
