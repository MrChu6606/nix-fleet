{ pkgs, ... }: {
  programs = {
    niri.enable = false;
    gamescope.enable = true;
    monique.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
