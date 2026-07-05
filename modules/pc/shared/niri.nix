{ pkgs, ... }: {
  programs = {
    niri.enable = true;
    gamescope.enable = true;
    monique.enable = true;
  };

  xdg.portal = {
    enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
