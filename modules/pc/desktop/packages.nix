{ pkgs, ... }: let
  stable = with pkgs; [
    gdu # storage tui
  ];
in {
  environment.systemPackages = stable;
}
