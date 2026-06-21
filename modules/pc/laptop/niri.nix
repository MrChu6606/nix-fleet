{ pkgs, ... }: {
  programs.niri.enable = true;
  programs.gamescope.enable = true;
  
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
