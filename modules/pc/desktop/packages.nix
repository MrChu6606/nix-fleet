{ pkgs, ... }: let
  stable = with pkgs; [
    wiremix # audio output tui
  ];
in {
  environment.systemPackages = stable;
}
